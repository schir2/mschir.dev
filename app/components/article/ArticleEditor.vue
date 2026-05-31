<script lang="ts" setup>
import type { ExposeParam } from 'md-editor-v3'
import type { ArticleCategory, ArticleTag, ArticleSeries, WritingStage } from '#shared/types/Article'

const props = defineProps<{
  articleId?: string
}>()

const supabase = useSupabaseClient()
const toast = useToast()
const router = useRouter()

// --- Form state ---
const title = ref('')
const slug = ref('')
const content = ref('')
const writingStage = ref<WritingStage>('idea')
const publishedAt = ref<string | null>(null)
const archivedAt = ref<string | null>(null)
const isPublished = computed(() => publishedAt.value !== null)
const isArchived = computed(() => archivedAt.value !== null)
const articleStatus = computed(() => deriveArticleStatus(publishedAt.value, archivedAt.value, writingStage.value))

const writingStageOptions: WritingStage[] = ['idea', 'outline', 'draft', 'ready']

function togglePublished(value: boolean) {
  publishedAt.value = value ? new Date().toISOString() : null
}

function toggleArchived(value: boolean) {
  archivedAt.value = value ? new Date().toISOString() : null
}
const categoryId = ref<string | null>(null)
const selectedTagIds = ref<string[]>([])
const seriesId = ref<string | null>(null)
const seriesSequenceNumber = ref<number | null>(null)
const imageUrl = ref<string | null>(null)
const slugLocked = ref(false)
const slugAutoMode = ref(true)

const heroImagePublicUrl = computed(() =>
  imageUrl.value
    ? supabase.storage.from('images').getPublicUrl(imageUrl.value).data.publicUrl
    : null
)

const heroImageInput = ref<HTMLInputElement | null>(null)

// --- Reference data ---
const categories = ref<ArticleCategory[]>([])
const tags = ref<ArticleTag[]>([])
const seriesList = ref<ArticleSeries[]>([])

// --- UI state ---
const saving = ref(false)
const loading = ref(true)
const currentArticleId = ref<string | null>(props.articleId ?? null)

// --- Inline creation inputs ---
const newCategoryName = ref('')
const newTagName = ref('')
const newSeriesTitle = ref('')

// --- Editor ref and height ---
const editorRef = ref<ExposeParam | null>(null)
const editorHeight = ref('600px')

function recalculateEditorHeight() {
  editorHeight.value = `${Math.max(400, window.innerHeight - 280)}px`
}

function applyHeading(level: number) {
  if (!editorRef.value) return
  const prefix = '#'.repeat(level) + ' '
  editorRef.value.insert((selectedText) =>
    selectedText
      ? { targetValue: prefix + selectedText, select: true }
      : { targetValue: prefix }
  )
}

function onEditorKeydown(event: KeyboardEvent) {
  if (!event.ctrlKey || !event.altKey) return
  const level = parseInt(event.key)
  if (isNaN(level) || level < 1 || level > 6) return
  event.preventDefault()
  applyHeading(level)
}

function generateSlug(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-')
    .trim()
    .substring(0, 200)
}

watch(title, (newTitle) => {
  if (slugAutoMode.value && !slugLocked.value) {
    slug.value = generateSlug(newTitle)
  }
})

function onSlugInput() {
  slugAutoMode.value = false
}

async function loadReferenceData() {
  const [categoriesResult, tagsResult, seriesResult] = await Promise.all([
    supabase.from('article_categories').select('id, name, slug, description').order('name'),
    supabase.from('article_tags').select('id, name, slug').order('name'),
    supabase.from('article_series').select('id, title, slug, description, author, created_at, updated_at').order('title'),
  ])

  if (categoriesResult.data) categories.value = categoriesResult.data
  if (tagsResult.data) tags.value = tagsResult.data
  if (seriesResult.data) seriesList.value = seriesResult.data
}

async function loadArticle(articleId: string) {
  const { data, error } = await supabase
    .from('articles')
    .select('id, title, slug, content, writing_stage, published_at, archived_at, image_url, category_id, series_id, series_sequence_number, article_tags_links(tag_id)')
    .eq('id', articleId)
    .single()

  if (error || !data) {
    toast.add({ severity: 'error', summary: 'Failed to load article', life: 4000 })
    return
  }

  title.value = data.title
  slug.value = data.slug
  content.value = data.content
  writingStage.value = data.writing_stage
  publishedAt.value = data.published_at
  archivedAt.value = data.archived_at
  categoryId.value = data.category_id
  selectedTagIds.value = data.article_tags_links.map((link: { tag_id: string }) => link.tag_id)
  seriesId.value = data.series_id
  seriesSequenceNumber.value = data.series_sequence_number
  imageUrl.value = data.image_url

  slugAutoMode.value = false
  if (data.published_at) slugLocked.value = true
}

onMounted(async () => {
  recalculateEditorHeight()
  window.addEventListener('resize', recalculateEditorHeight)

  await loadReferenceData()
  if (currentArticleId.value) {
    await loadArticle(currentArticleId.value)
  }
  loading.value = false
})

onUnmounted(() => {
  window.removeEventListener('resize', recalculateEditorHeight)
})

async function autoAssignSequenceNumber(selectedSeriesId: string) {
  const { data } = await supabase
    .from('articles')
    .select('series_sequence_number')
    .eq('series_id', selectedSeriesId)
    .order('series_sequence_number', { ascending: false })
    .limit(1)
    .maybeSingle()

  seriesSequenceNumber.value = (data?.series_sequence_number ?? 0) + 1
}

async function onSeriesChange(event: { value: string | null }) {
  if (!event.value) {
    seriesSequenceNumber.value = null
    return
  }
  await autoAssignSequenceNumber(event.value)
}

async function save() {
  if (saving.value) return
  saving.value = true

  try {
    const articleData = {
      title: title.value,
      slug: slug.value,
      content: content.value,
      writing_stage: writingStage.value,
      published_at: publishedAt.value,
      archived_at: archivedAt.value,
      image_url: imageUrl.value,
      category_id: categoryId.value,
      series_id: seriesId.value,
      series_sequence_number: seriesSequenceNumber.value,
    }

    let savedId: string

    if (currentArticleId.value) {
      const { data, error } = await supabase
        .from('articles')
        .update(articleData)
        .eq('id', currentArticleId.value)
        .select('id')
        .single()
      if (error) throw error
      savedId = data.id
    } else {
      const { data, error } = await supabase
        .from('articles')
        .insert(articleData)
        .select('id')
        .single()
      if (error) throw error
      savedId = data.id
      currentArticleId.value = savedId
      await router.replace(`/admin/articles/${savedId}`)
    }

    await supabase.from('article_tags_links').delete().eq('article_id', savedId)
    if (selectedTagIds.value.length > 0) {
      const { error: tagsError } = await supabase
        .from('article_tags_links')
        .insert(selectedTagIds.value.map((tagId) => ({ article_id: savedId, tag_id: tagId })))
      if (tagsError) throw tagsError
    }

    if (publishedAt.value) slugLocked.value = true

    toast.add({ severity: 'success', summary: 'Article saved', life: 3000 })
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Unknown error'
    toast.add({ severity: 'error', summary: 'Save failed', detail: message, life: 4000 })
  } finally {
    saving.value = false
  }
}

async function uploadHeroImage(file: File) {
  const extension = file.name.split('.').pop() ?? 'jpg'
  const newPath = `article-heroes/${crypto.randomUUID()}.${extension}`

  if (imageUrl.value) {
    await supabase.storage.from('images').remove([imageUrl.value])
  }

  const { error } = await supabase.storage.from('images').upload(newPath, file)

  if (error) {
    toast.add({ severity: 'error', summary: 'Hero image upload failed', detail: error.message, life: 4000 })
    return
  }

  imageUrl.value = newPath
}

async function onHeroImageChange(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return
  await uploadHeroImage(file)
  if (heroImageInput.value) heroImageInput.value.value = ''
}

async function clearHeroImage() {
  if (imageUrl.value) {
    await supabase.storage.from('images').remove([imageUrl.value])
    imageUrl.value = null
  }
}

async function handleEditorImageUpload(files: File[], callback: (urls: string[]) => void) {
  const urls: string[] = []

  for (const file of files) {
    const extension = file.name.split('.').pop() ?? 'jpg'
    const path = `article-content/${crypto.randomUUID()}.${extension}`

    const { error } = await supabase.storage.from('images').upload(path, file)

    if (error) {
      toast.add({ severity: 'error', summary: 'Image upload failed', detail: error.message, life: 4000 })
      continue
    }

    const { data: { publicUrl } } = supabase.storage.from('images').getPublicUrl(path)
    urls.push(publicUrl)
  }

  callback(urls)
}

async function createCategory() {
  const name = newCategoryName.value.trim()
  if (!name) return

  const { data, error } = await supabase
    .from('article_categories')
    .insert({ name, slug: generateSlug(name) })
    .select('id, name, slug, description')
    .single()

  if (error) {
    toast.add({ severity: 'error', summary: 'Failed to create category', detail: error.message, life: 4000 })
    return
  }

  categories.value.push(data)
  categoryId.value = data.id
  newCategoryName.value = ''
}

async function createTag() {
  const name = newTagName.value.trim()
  if (!name) return

  const { data, error } = await supabase
    .from('article_tags')
    .insert({ name, slug: generateSlug(name) })
    .select('id, name, slug')
    .single()

  if (error) {
    toast.add({ severity: 'error', summary: 'Failed to create tag', detail: error.message, life: 4000 })
    return
  }

  tags.value.push(data)
  selectedTagIds.value = [...selectedTagIds.value, data.id]
  newTagName.value = ''
}

async function createSeries() {
  const seriesTitle = newSeriesTitle.value.trim()
  if (!seriesTitle) return

  const { data, error } = await supabase
    .from('article_series')
    .insert({ title: seriesTitle, slug: generateSlug(seriesTitle), description: '' })
    .select('id, title, slug, description, author, created_at, updated_at')
    .single()

  if (error) {
    toast.add({ severity: 'error', summary: 'Failed to create series', detail: error.message, life: 4000 })
    return
  }

  seriesList.value.push(data)
  seriesId.value = data.id
  seriesSequenceNumber.value = 1
  newSeriesTitle.value = ''
}
</script>

<template>
  <div class="flex flex-col" :style="{ height: '100dvh' }">

    <!-- Toolbar -->
    <div class="flex items-center gap-3 px-4 py-3 border-b shrink-0">
      <p-button
        icon="pi pi-arrow-left"
        text
        size="small"
        @click="router.push('/admin/articles')"
      />
      <span class="font-semibold text-lg flex-1">
        {{ currentArticleId ? 'Edit Article' : 'New Article' }}
      </span>
      <p-tag
        :value="articleStatus.label"
        :severity="articleStatus.severity"
      />
      <p-button
        label="Save"
        icon="pi pi-save"
        :loading="saving"
        :disabled="saving || loading"
        @click="save"
      />
    </div>

    <p-progress-spinner v-if="loading" class="m-auto" />

    <template v-else>
      <!-- Metadata bar -->
      <div class="px-4 py-3 border-b shrink-0 flex flex-col gap-3">

        <!-- Row 1: Title + Slug + Hero image -->
        <div class="flex gap-3 items-center">
          <p-input-text
            v-model="title"
            placeholder="Article title"
            class="flex-1 font-medium"
          />
          <div class="flex items-center gap-2">
            <span class="text-sm text-color-secondary shrink-0">Slug:</span>
            <p-input-text
              v-model="slug"
              placeholder="article-slug"
              :disabled="slugLocked"
              class="w-56 font-mono text-sm"
              @input="onSlugInput"
            />
            <icon v-if="slugLocked" name="pi pi-lock" class="text-color-secondary text-sm" />
          </div>

          <!-- Hero image -->
          <input
            ref="heroImageInput"
            type="file"
            accept="image/png,image/jpeg,image/webp"
            class="hidden"
            @change="onHeroImageChange"
          />
          <div class="flex items-center gap-2 shrink-0">
            <img
              v-if="heroImagePublicUrl"
              :src="heroImagePublicUrl"
              alt="Hero image preview"
              class="h-9 w-14 object-cover rounded border"
            />
            <p-button
              v-if="heroImagePublicUrl"
              icon="pi pi-times"
              size="small"
              text
              severity="danger"
              @click="clearHeroImage"
            />
            <p-button
              :icon="heroImagePublicUrl ? 'pi pi-refresh' : 'pi pi-image'"
              :label="heroImagePublicUrl ? 'Replace' : 'Hero Image'"
              size="small"
              text
              @click="heroImageInput?.click()"
            />
          </div>
        </div>

        <!-- Row 2: Category, Tags, Series, Published -->
        <div class="flex gap-3 items-start flex-wrap">

          <!-- Category -->
          <p-select
            v-model="categoryId"
            :options="categories"
            option-label="name"
            option-value="id"
            filter
            show-clear
            placeholder="Category"
            class="w-44"
          >
            <template #footer>
              <div class="p-2 border-t flex gap-2">
                <p-input-text
                  v-model="newCategoryName"
                  placeholder="New category…"
                  size="small"
                  class="flex-1"
                  @keydown.enter.prevent="createCategory"
                />
                <p-button size="small" label="Add" :disabled="!newCategoryName.trim()" @click="createCategory" />
              </div>
            </template>
          </p-select>

          <!-- Tags -->
          <p-multi-select
            v-model="selectedTagIds"
            :options="tags"
            option-label="name"
            option-value="id"
            filter
            placeholder="Tags"
            class="w-52"
            display="chip"
          >
            <template #footer>
              <div class="p-2 border-t flex gap-2">
                <p-input-text
                  v-model="newTagName"
                  placeholder="New tag…"
                  size="small"
                  class="flex-1"
                  @keydown.enter.prevent="createTag"
                />
                <p-button size="small" label="Add" :disabled="!newTagName.trim()" @click="createTag" />
              </div>
            </template>
          </p-multi-select>

          <!-- Series -->
          <p-select
            v-model="seriesId"
            :options="seriesList"
            option-label="title"
            option-value="id"
            filter
            show-clear
            placeholder="Series"
            class="w-44"
            @change="onSeriesChange"
          >
            <template #footer>
              <div class="p-2 border-t flex gap-2">
                <p-input-text
                  v-model="newSeriesTitle"
                  placeholder="New series…"
                  size="small"
                  class="flex-1"
                  @keydown.enter.prevent="createSeries"
                />
                <p-button size="small" label="Add" :disabled="!newSeriesTitle.trim()" @click="createSeries" />
              </div>
            </template>
          </p-select>

          <!-- Sequence number (visible only when series is selected) -->
          <div v-if="seriesId" class="flex items-center gap-2">
            <span class="text-sm text-color-secondary shrink-0">#</span>
            <p-input-number
              v-model="seriesSequenceNumber"
              :min="1"
              show-buttons
              class="w-24"
            />
          </div>

          <!-- Writing stage -->
          <p-select-button
            v-model="writingStage"
            :options="writingStageOptions"
            :disabled="isPublished"
          />

          <!-- Published toggle -->
          <div class="flex items-center gap-2 ml-auto">
            <label class="text-sm">Published</label>
            <p-toggle-switch
              :model-value="isPublished"
              @update:model-value="togglePublished"
            />
          </div>

          <!-- Archived toggle -->
          <div v-if="isPublished" class="flex items-center gap-2">
            <label class="text-sm">Archived</label>
            <p-toggle-switch
              :model-value="isArchived"
              @update:model-value="toggleArchived"
            />
          </div>

        </div>
      </div>

      <!-- Editor -->
      <div class="flex-1 overflow-hidden" @keydown="onEditorKeydown">
        <client-only>
          <md-editor
            ref="editorRef"
            v-model="content"
            language="en-US"
            theme="dark"
            :style="{ height: editorHeight }"
            :on-upload-img="handleEditorImageUpload"
          />
        </client-only>
      </div>

    </template>
  </div>
</template>
