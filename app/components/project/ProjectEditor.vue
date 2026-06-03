<script lang="ts" setup>
const props = defineProps<{
  projectId?: string
}>()

const supabase = useSupabaseClient()
const toast = useToast()
const router = useRouter()
const confirm = useConfirm()
const mdTheme = useMdEditorTheme()

// --- Form state ---
const projectName = ref('')
const slug = ref('')
const slugAutoMode = ref(true)
const description = ref('')
const summary = ref<string | null>(null)
const companyId = ref<string | null>(null)
const year = ref<number>(new Date().getFullYear())
const selectedSkillIds = ref<string[]>([])
const imageUrl = ref<string | null>(null)
const stagedImageFile = ref<File | null>(null)

// --- Featured state ---
const isFeatured = ref(false)
const featuredTagline = ref('')
const featuredDisplayOrder = ref(1)
const featuredProjectId = ref<string | null>(null)

// --- Reference data ---
type Company = { id: string; name: string }
type SkillWithCategory = { id: string; name: string; skill_categories: { name: string } | null }
type SkillGroupOption = { label: string; items: { label: string; value: string }[] }

const companies = ref<Company[]>([])
const skillGroups = ref<SkillGroupOption[]>([])

// --- UI state ---
const saving = ref(false)
const loading = ref(true)
const currentProjectId = ref<string | null>(props.projectId ?? null)
const heroImageInput = ref<HTMLInputElement | null>(null)

// --- Editor height ---
const editorHeight = ref('600px')

function recalculateEditorHeight() {
  editorHeight.value = `${Math.max(400, window.innerHeight - 320)}px`
}

const imagePreviewUrl = computed<string | null>(() => {
  if (stagedImageFile.value) {
    return URL.createObjectURL(stagedImageFile.value)
  }
  if (imageUrl.value) {
    return supabase.storage.from('images').getPublicUrl(imageUrl.value).data.publicUrl
  }
  return null
})

watch(projectName, (newName) => {
  if (slugAutoMode.value) {
    slug.value = generateSlug(newName)
  }
})

function onSlugInput() {
  slugAutoMode.value = false
}

async function loadReferenceData() {
  const [companiesResult, skillsResult] = await Promise.all([
    supabase.from('companies').select('id, name').order('name'),
    supabase.from('skills').select('id, name, skill_categories(name)').order('name'),
  ])

  if (companiesResult.data) {
    companies.value = companiesResult.data
  }

  if (skillsResult.data) {
    const groupMap = new Map<string, { label: string; value: string }[]>()
    for (const skill of skillsResult.data as SkillWithCategory[]) {
      const categoryName = skill.skill_categories?.name ?? 'Uncategorized'
      if (!groupMap.has(categoryName)) {
        groupMap.set(categoryName, [])
      }
      groupMap.get(categoryName)!.push({ label: skill.name, value: skill.id })
    }
    skillGroups.value = Array.from(groupMap.entries())
      .sort(([nameA], [nameB]) => nameA.localeCompare(nameB))
      .map(([label, items]) => ({ label, items }))
  }
}

async function loadProject(projectId: string) {
  const { data, error } = await supabase
    .from('projects')
    .select('id, name, slug, description, summary, company_id, year, image_url, project_skills(skill_id)')
    .eq('id', projectId)
    .single()

  if (error || !data) {
    toast.add({ severity: 'error', summary: 'Failed to load project', life: 4000 })
    return
  }

  projectName.value = data.name
  slug.value = data.slug
  description.value = data.description
  summary.value = data.summary
  companyId.value = data.company_id
  year.value = data.year
  imageUrl.value = data.image_url
  selectedSkillIds.value = data.project_skills.map((link: { skill_id: string }) => link.skill_id)
  slugAutoMode.value = false

  const { data: featuredData } = await supabase
    .from('featured_projects')
    .select('id, tagline, display_order')
    .eq('project_id', projectId)
    .maybeSingle()

  if (featuredData) {
    isFeatured.value = true
    featuredProjectId.value = featuredData.id
    featuredTagline.value = featuredData.tagline
    featuredDisplayOrder.value = featuredData.display_order
  }
}

onMounted(async () => {
  recalculateEditorHeight()
  window.addEventListener('resize', recalculateEditorHeight)

  await loadReferenceData()
  if (currentProjectId.value) {
    await loadProject(currentProjectId.value)
  }
  loading.value = false
})

onUnmounted(() => {
  window.removeEventListener('resize', recalculateEditorHeight)
})

function onImageFilePicked(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return
  stagedImageFile.value = file
}

function clearImage() {
  stagedImageFile.value = null
  imageUrl.value = null
  if (heroImageInput.value) heroImageInput.value.value = ''
}

async function syncProjectSkills(projectId: string) {
  await supabase.from('project_skills').delete().eq('project_id', projectId)
  if (selectedSkillIds.value.length > 0) {
    const { error: skillsError } = await supabase
      .from('project_skills')
      .insert(selectedSkillIds.value.map((skillId) => ({ project_id: projectId, skill_id: skillId })))
    if (skillsError) throw skillsError
  }
}

async function syncFeatured(projectId: string) {
  if (isFeatured.value) {
    const { error } = await supabase
      .from('featured_projects')
      .upsert(
        { id: featuredProjectId.value ?? undefined, project_id: projectId, tagline: featuredTagline.value, display_order: featuredDisplayOrder.value },
        { onConflict: 'project_id' },
      )
    if (error) throw error
  } else {
    await supabase.from('featured_projects').delete().eq('project_id', projectId)
  }
}

async function save() {
  if (saving.value) return
  saving.value = true

  if (isFeatured.value && !featuredTagline.value.trim()) {
    toast.add({ severity: 'warn', summary: 'Tagline required', detail: 'A featured project must have a tagline.', life: 4000 })
    saving.value = false
    return
  }

  try {
    let newImagePath = imageUrl.value

    if (stagedImageFile.value) {
      newImagePath = await useImageUpload(
        'images',
        'project-images',
        stagedImageFile.value,
        imageUrl.value ?? undefined,
      )
    }

    const projectData = {
      name: projectName.value,
      slug: slug.value,
      description: description.value,
      summary: summary.value?.trim() || null,
      company_id: companyId.value,
      year: year.value,
      image_url: newImagePath,
    }

    let savedId: string

    if (currentProjectId.value) {
      const { data, error } = await supabase
        .from('projects')
        .update(projectData)
        .eq('id', currentProjectId.value)
        .select('id')
        .single()
      if (error) throw error
      savedId = data.id
    } else {
      const { data, error } = await supabase
        .from('projects')
        .insert(projectData)
        .select('id')
        .single()
      if (error) throw error
      savedId = data.id
      currentProjectId.value = savedId
    }

    imageUrl.value = newImagePath
    stagedImageFile.value = null

    await syncProjectSkills(savedId)
    await syncFeatured(savedId)

    toast.add({ severity: 'success', summary: 'Project saved', life: 3000 })
    router.push('/admin/projects')
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Unknown error'
    toast.add({ severity: 'error', summary: 'Save failed', detail: message, life: 4000 })
  } finally {
    saving.value = false
  }
}

function confirmDelete(event: MouseEvent) {
  confirm.require({
    target: event.currentTarget as HTMLElement,
    header: 'Delete Project',
    message: 'Delete this project? This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    acceptLabel: 'Delete',
    rejectLabel: 'Cancel',
    acceptProps: { severity: 'danger' },
    rejectProps: { severity: 'secondary', outlined: true },
    accept: () => deleteProject(),
  })
}

async function deleteProject() {
  if (!currentProjectId.value) return

  const { error } = await supabase
    .from('projects')
    .delete()
    .eq('id', currentProjectId.value)

  if (error) {
    toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Project deleted', life: 3000 })
  router.push('/admin/projects')
}
</script>

<template>
  <div class="flex flex-col" :style="{ height: '100dvh' }">
    <p-confirm-popup />

    <!-- Toolbar -->
    <div class="flex items-center gap-3 px-4 py-3 border-b shrink-0">
      <p-button
        icon="pi pi-arrow-left"
        text
        size="small"
        @click="router.push('/admin/projects')"
      />
      <span class="font-semibold text-lg flex-1">
        {{ currentProjectId ? 'Edit Project' : 'New Project' }}
      </span>
      <p-button
        v-if="currentProjectId"
        icon="pi pi-trash"
        text
        severity="danger"
        size="small"
        label="Delete"
        @click="confirmDelete($event)"
      />
      <p-button
        v-if="currentProjectId && slug"
        icon="pi pi-external-link"
        text
        size="small"
        label="View"
        tag="a"
        :href="`/projects/${slug}`"
        target="_blank"
      />
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

        <!-- Row 1: Name + Slug + Hero image -->
        <div class="flex gap-3 items-end">
          <div class="flex flex-col gap-1 flex-1">
            <label class="text-xs text-color-secondary">Name</label>
            <p-input-text v-model="projectName" class="w-full font-medium" />
          </div>
          <div class="flex flex-col gap-1">
            <label class="text-xs text-color-secondary">Slug</label>
            <p-input-text v-model="slug" class="w-56 font-mono text-sm" @input="onSlugInput" />
          </div>
          <input
            ref="heroImageInput"
            type="file"
            accept="image/png,image/jpeg,image/webp"
            class="hidden"
            @change="onImageFilePicked"
          />
          <div class="flex items-center gap-2 shrink-0">
            <img
              v-if="imagePreviewUrl"
              :src="imagePreviewUrl"
              alt="Hero image preview"
              class="h-9 w-14 object-cover rounded border"
            />
            <p-button
              v-if="imagePreviewUrl"
              icon="pi pi-times"
              size="small"
              text
              severity="danger"
              @click="clearImage"
            />
            <p-button
              :icon="imagePreviewUrl ? 'pi pi-refresh' : 'pi pi-image'"
              :label="imagePreviewUrl ? 'Replace' : 'Hero Image'"
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

        <!-- Row 3: Company + Year + Skills + Featured -->
        <div class="flex gap-3 items-center flex-wrap">
          <div class="flex flex-col gap-1 w-44">
            <label class="text-xs text-color-secondary">Company</label>
            <p-select v-model="companyId" :options="companies" option-label="name" option-value="id" show-clear filter class="w-full" />
          </div>
          <div class="flex flex-col gap-1 w-28">
            <label class="text-xs text-color-secondary">Year</label>
            <p-input-number v-model="year" :min="1900" :max="2100" :use-grouping="false" class="w-full" />
          </div>
          <div class="flex flex-col gap-1 w-64">
            <label class="text-xs text-color-secondary">Skills</label>
            <p-multi-select v-model="selectedSkillIds" :options="skillGroups" option-group-label="label" option-group-children="items" option-label="label" option-value="value" filter display="chip" class="w-full" />
          </div>
          <div class="flex flex-col gap-1 ml-auto">
            <label class="text-xs text-color-secondary">Featured</label>
            <p-toggle-switch v-model="isFeatured" />
          </div>
        </div>

        <!-- Row 4: Featured fields (when toggled on) -->
        <template v-if="isFeatured">
          <div class="flex gap-3 items-end">
            <div class="flex flex-col gap-1 flex-1">
              <label class="text-xs text-color-secondary">Portfolio tagline</label>
              <p-textarea v-model="featuredTagline" :rows="2" auto-resize class="w-full" />
            </div>
            <div class="flex flex-col gap-1 w-20 shrink-0">
              <label class="text-xs text-color-secondary">Order</label>
              <p-input-number v-model="featuredDisplayOrder" :min="1" :use-grouping="false" class="w-full" />
            </div>
          </div>
        </template>

      </div>

      <!-- Markdown editor -->
      <div class="flex-1 overflow-hidden">
        <client-only>
          <md-editor
            v-model="description"
            language="en-US"
            :theme="mdTheme"
            :style="{ height: editorHeight }"
          />
        </client-only>
      </div>

    </template>
  </div>
</template>
