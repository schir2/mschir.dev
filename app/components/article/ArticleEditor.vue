<script lang="ts" setup>
import type { ExposeParam } from 'md-editor-v3'
import type { ArticleCategory, ArticleTag, ArticleSeries, WritingStage } from '#shared/types/Article'

const props = defineProps<{
  articleId?: string
}>()

const supabase = useSupabaseClient()
const toast = useToast()
const router = useRouter()
const confirm = useConfirm()
const mdTheme = useMdEditorTheme()

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

function confirmPublish() {
  confirm.require({
    header: 'Publish article',
    message: 'This will make the article visible to all visitors and lock the slug so existing links stay valid. You can unpublish it at any time.',
    icon: 'material-symbols:send',
    acceptLabel: 'Publish',
    rejectLabel: 'Cancel',
    acceptProps: { severity: 'success' },
    rejectProps: { severity: 'secondary', outlined: true },
    accept: async () => { togglePublished(true); await save() },
  })
}

function confirmUnpublish() {
  confirm.require({
    header: 'Unpublish article',
    message: 'This will hide the article from all visitors. It will no longer appear in any article listings. You can re-publish it at any time.',
    icon: 'material-symbols:visibility-off',
    acceptLabel: 'Unpublish',
    rejectLabel: 'Cancel',
    acceptProps: { severity: 'danger' },
    rejectProps: { severity: 'secondary', outlined: true },
    accept: async () => { togglePublished(false); await save() },
  })
}

function toggleArchived(value: boolean) {
  archivedAt.value = value ? new Date().toISOString() : null
}
const summary = ref<string | null>(null)
const isFeatured = ref(false)
const featuredReason = ref<string | null>(null)
const featuredArticleId = ref<string | null>(null)
const categoryId = ref<string | null>(null)
const selectedTagIds = ref<string[]>([])
const seriesId = ref<string | null>(null)
const seriesSequenceNumber = ref<number | null>(null)
const imageUrl = ref<string | null>(null)
const slugLocked = computed(() => publishedAt.value !== null)
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
    .select('id, title, slug, content, summary, writing_stage, published_at, archived_at, image_url, category_id, series_id, series_sequence_number, article_tags_links(tag_id)')
    .eq('id', articleId)
    .single()

  if (error || !data) {
    toast.add({ severity: 'error', summary: 'Failed to load article', life: 4000 })
    return
  }

  title.value = data.title
  slug.value = data.slug
  content.value = data.content
  summary.value = data.summary
  writingStage.value = data.writing_stage
  publishedAt.value = data.published_at
  archivedAt.value = data.archived_at
  categoryId.value = data.category_id
  selectedTagIds.value = data.article_tags_links.map((link: { tag_id: string }) => link.tag_id)
  seriesId.value = data.series_id
  seriesSequenceNumber.value = data.series_sequence_number
  imageUrl.value = data.image_url

  slugAutoMode.value = false

  const { data: featuredData } = await supabase
    .from('featured_articles')
    .select('id, featured_reason')
    .eq('article_id', articleId)
    .maybeSingle()

  if (featuredData) {
    isFeatured.value = true
    featuredArticleId.value = featuredData.id
    featuredReason.value = featuredData.featured_reason
  }
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

async function syncFeatured(articleId: string) {
  if (isFeatured.value) {
    const { error } = await supabase
      .from('featured_articles')
      .upsert(
        { id: featuredArticleId.value ?? undefined, article_id: articleId, featured_reason: featuredReason.value?.trim() || null },
        { onConflict: 'article_id' },
      )
    if (error) throw error
  } else {
    await supabase.from('featured_articles').delete().eq('article_id', articleId)
  }
}

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
      summary: summary.value?.trim() || null,
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

    await syncFeatured(savedId)

    toast.add({ severity: 'success', summary: 'Article saved', life: 3000 })
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Unknown error'
    toast.add({ severity: 'error', summary: 'Save failed', detail: message, life: 4000 })
  } finally {
    saving.value = false
  }
}

async function uploadHeroImage(file: File) {
  try {
    imageUrl.value = await useImageUpload('images', 'article-heroes', file, imageUrl.value ?? undefined)
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Unknown error'
    toast.add({ severity: 'error', summary: 'Hero image upload failed', detail: message, life: 4000 })
  }
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

// Uses useImageUpload for the upload step; getPublicUrl is still called directly because the composable returns a path, not a URL.
async function handleEditorImageUpload(files: File[], callback: (urls: string[]) => void) {
  const urls: string[] = []

  for (const file of files) {
    try {
      const uploadedPath = await useImageUpload('images', 'article-content', file)
      const { data: { publicUrl } } = supabase.storage.from('images').getPublicUrl(uploadedPath)
      urls.push(publicUrl)
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : 'Unknown error'
      toast.add({ severity: 'error', summary: 'Image upload failed', detail: message, life: 4000 })
    }
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
      <nuxt-link
        v-if="isPublished && slug"
        :to="`/articles/${slug}`"
        target="_blank"
      >
        <p-button
          icon="pi pi-external-link"
          label="View"
          text
          size="small"
        />
      </nuxt-link>
      <p-button
        label="Save"
        severity="success"
        :loading="saving"
        :disabled="saving || loading"
        @click="save"
      >
        <template #icon>
          <icon name="material-symbols:save" class="text-lg"/>
        </template>
      </p-button>
    </div>

    <p-progress-spinner v-if="loading" class="m-auto" />

    <template v-else>
      <!-- Metadata bar -->
      <div class="px-4 py-3 border-b shrink-0 flex flex-col gap-3">

        <!-- Row 1: Title + Slug + Hero image -->
        <div class="flex gap-3 items-end">
          <div class="flex flex-col gap-1 flex-1">
            <label class="text-xs text-color-secondary">Title</label>
            <p-input-text v-model="title" class="w-full font-medium" />
          </div>
          <div class="flex flex-col gap-1">
            <label class="text-xs text-color-secondary">Slug</label>
            <div class="flex items-center gap-2">
              <p-input-text v-model="slug" :disabled="slugLocked" class="w-56 font-mono text-sm" @input="onSlugInput" />
              <icon v-if="slugLocked" name="pi pi-lock" class="text-color-secondary text-sm" />
            </div>
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

        <!-- Row 2: Summary -->
        <div class="flex flex-col gap-1">
          <label class="text-xs text-color-secondary">Summary</label>
          <p-textarea v-model="summary" :rows="2" class="w-full" auto-resize />
        </div>

        <!-- Row 3: Category, Tags, Series, Published -->
        <div class="flex gap-3 items-center flex-wrap">

          <!-- Category -->
          <div class="flex flex-col gap-1 w-44">
            <label class="text-xs text-color-secondary">Category</label>
            <p-select
              v-model="categoryId"
              :options="categories"
              option-label="name"
              option-value="id"
              filter
              show-clear
              class="w-full"
            >
              <template #footer>
                <div class="p-2 border-t flex gap-2">
                  <p-input-text v-model="newCategoryName" placeholder="New category…" size="small" class="flex-1" @keydown.enter.prevent="createCategory" />
                  <p-button size="small" label="Add" :disabled="!newCategoryName.trim()" @click="createCategory" />
                </div>
              </template>
            </p-select>
          </div>

          <!-- Tags -->
          <div class="flex flex-col gap-1 w-72">
            <label class="text-xs text-color-secondary">Tags</label>
            <p-multi-select
              v-model="selectedTagIds"
              :options="tags"
              option-label="name"
              option-value="id"
              filter
              display="chip"
              class="w-full"
            >
              <template #footer>
                <div class="p-2 border-t flex gap-2">
                  <p-input-text v-model="newTagName" placeholder="New tag…" size="small" class="flex-1" @keydown.enter.prevent="createTag" />
                  <p-button size="small" label="Add" :disabled="!newTagName.trim()" @click="createTag" />
                </div>
              </template>
            </p-multi-select>
          </div>

          <!-- Series -->
          <div class="flex flex-col gap-1 w-44">
            <label class="text-xs text-color-secondary">Series</label>
            <p-select
              v-model="seriesId"
              :options="seriesList"
              option-label="title"
              option-value="id"
              filter
              show-clear
              class="w-full"
              @change="onSeriesChange"
            >
              <template #footer>
                <div class="p-2 border-t flex gap-2">
                  <p-input-text v-model="newSeriesTitle" placeholder="New series…" size="small" class="flex-1" @keydown.enter.prevent="createSeries" />
                  <p-button size="small" label="Add" :disabled="!newSeriesTitle.trim()" @click="createSeries" />
                </div>
              </template>
            </p-select>
          </div>

          <!-- Sequence number (visible only when series is selected) -->
          <div v-if="seriesId" class="flex flex-col gap-1 w-24">
            <label class="text-xs text-color-secondary">#</label>
            <p-input-number v-model="seriesSequenceNumber" :min="1" show-buttons class="w-full" />
          </div>

          <!-- Writing stage -->
          <div class="flex flex-col gap-1">
            <label class="text-xs text-color-secondary">Stage</label>
            <p-select-button
              v-model="writingStage"
              :options="writingStageOptions"
              :disabled="isPublished"
            />
          </div>

          <!-- Featured toggle -->
          <div class="flex flex-col gap-1">
            <label class="text-xs text-color-secondary">Featured</label>
            <p-toggle-switch v-model="isFeatured" />
          </div>

          <!-- Archived toggle (only when published) -->
          <div v-if="isPublished" class="flex flex-col gap-1">
            <label class="text-xs text-color-secondary">Archived</label>
            <p-toggle-switch
              :model-value="isArchived"
              @update:model-value="toggleArchived"
            />
          </div>

          <!-- Publish / Unpublish (last action) -->
          <div class="flex flex-col gap-1 ml-auto">
            <label class="text-xs text-color-secondary opacity-0">.</label>
            <p-button
              v-if="!isPublished"
              label="Publish"
              icon="pi pi-send"
              severity="success"
              size="small"
              @click="confirmPublish"
            />
            <p-button
              v-else
              label="Unpublish"
              icon="pi pi-eye-slash"
              severity="secondary"
              outlined
              size="small"
              @click="confirmUnpublish"
            />
          </div>

        </div>

        <!-- Featured reason (visible only when featured) -->
        <div v-if="isFeatured" class="flex flex-col gap-1">
          <label class="text-xs text-color-secondary">Featured reason (optional)</label>
          <p-input-text v-model="featuredReason" placeholder="e.g. Editor's pick" class="w-full" />
        </div>

      </div>

      <!-- Editor -->
      <div class="flex-1 overflow-hidden" @keydown="onEditorKeydown">
        <client-only>
          <md-editor
            ref="editorRef"
            v-model="content"
            language="en-US"
            :theme="mdTheme"
            :style="{ height: editorHeight }"
            :on-upload-img="handleEditorImageUpload"
          />
        </client-only>
      </div>

    </template>
  </div>
</template>
