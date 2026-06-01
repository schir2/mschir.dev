<script lang="ts" setup>
const props = defineProps<{
  projectId?: string
}>()

const supabase = useSupabaseClient()
const toast = useToast()
const router = useRouter()
const confirm = useConfirm()

// --- Form state ---
const projectName = ref('')
const description = ref('')
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

const imagePreviewUrl = computed<string | null>(() => {
  if (stagedImageFile.value) {
    return URL.createObjectURL(stagedImageFile.value)
  }
  if (imageUrl.value) {
    return supabase.storage.from('images').getPublicUrl(imageUrl.value).data.publicUrl
  }
  return null
})

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
    .select('id, name, description, company_id, year, image_url, project_skills(skill_id)')
    .eq('id', projectId)
    .single()

  if (error || !data) {
    toast.add({ severity: 'error', summary: 'Failed to load project', life: 4000 })
    return
  }

  projectName.value = data.name
  description.value = data.description
  companyId.value = data.company_id
  year.value = data.year
  imageUrl.value = data.image_url
  selectedSkillIds.value = data.project_skills.map((link: { skill_id: string }) => link.skill_id)

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
  await loadReferenceData()
  if (currentProjectId.value) {
    await loadProject(currentProjectId.value)
  }
  loading.value = false
})

function onImageFilePicked(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return
  stagedImageFile.value = file
}

function clearImage() {
  stagedImageFile.value = null
  imageUrl.value = null
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
      description: description.value,
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
    message: 'Delete this project? This cannot be undone.',
    icon: 'pi pi-exclamation-triangle',
    acceptClass: 'p-button-danger',
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
  <div class="p-6 max-w-2xl mx-auto">
    <p-confirm-popup />

    <!-- Toolbar -->
    <div class="flex items-center gap-3 mb-6">
      <p-button
        icon="pi pi-arrow-left"
        text
        size="small"
        @click="router.push('/admin/projects')"
      />
      <h1 class="text-2xl font-bold flex-1">
        {{ currentProjectId ? 'Edit Project' : 'New Project' }}
      </h1>
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
        label="Save"
        icon="pi pi-save"
        :loading="saving"
        :disabled="saving || loading"
        @click="save"
      />
    </div>

    <p-progress-spinner v-if="loading" class="block mx-auto" />

    <div v-else class="flex flex-col gap-5">

      <!-- Name -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Name <span class="text-red-500">*</span></label>
        <p-input-text v-model="projectName" placeholder="Project name" class="w-full" />
      </div>

      <!-- Description -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Description <span class="text-red-500">*</span></label>
        <p-textarea v-model="description" placeholder="Project description" rows="4" auto-resize class="w-full" />
      </div>

      <!-- Year -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Year <span class="text-red-500">*</span></label>
        <p-input-number v-model="year" :min="1900" :max="2100" :use-grouping="false" class="w-36" />
      </div>

      <!-- Hero Image -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Hero Image</label>
        <img
          v-if="imagePreviewUrl"
          :src="imagePreviewUrl"
          alt="Hero image preview"
          class="project-image-preview"
        />
        <input type="file" accept="image/png,image/jpeg,image/webp" @change="onImageFilePicked" />
        <p-button
          v-if="imageUrl || stagedImageFile"
          label="Remove image"
          text
          severity="danger"
          size="small"
          @click="clearImage"
        />
      </div>

      <!-- Company -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Company</label>
        <p-select
          v-model="companyId"
          :options="companies"
          option-label="name"
          option-value="id"
          show-clear
          filter
          placeholder="None"
          class="w-full"
        />
      </div>

      <!-- Skills -->
      <div class="flex flex-col gap-2">
        <label class="font-medium">Skills</label>
        <p-multi-select
          v-model="selectedSkillIds"
          :options="skillGroups"
          option-group-label="label"
          option-group-children="items"
          option-label="label"
          option-value="value"
          filter
          display="chip"
          placeholder="Select skills"
          class="w-full"
        />
      </div>

      <!-- Featured -->
      <div class="flex flex-col gap-3">
        <div class="flex items-center gap-2">
          <p-toggle-switch v-model="isFeatured" input-id="featured-toggle" />
          <label for="featured-toggle" class="font-medium cursor-pointer">Featured on Portfolio</label>
        </div>
        <template v-if="isFeatured">
          <div class="flex flex-col gap-2">
            <label class="font-medium">Tagline <span class="text-red-500">*</span></label>
            <p-textarea v-model="featuredTagline" placeholder="Short hook for the portfolio page" rows="2" auto-resize class="w-full" />
          </div>
          <div class="flex flex-col gap-2">
            <label class="font-medium">Display Order</label>
            <p-input-number v-model="featuredDisplayOrder" :min="1" :use-grouping="false" class="w-24" />
          </div>
        </template>
      </div>

    </div>
  </div>
</template>

<style scoped>
.project-image-preview {
  max-width: 100%;
  max-height: 200px;
  object-fit: cover;
  border-radius: var(--p-border-radius-md, 6px);
}
</style>
