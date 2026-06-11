<script lang="ts" setup>
import type {ProjectDetail} from '#shared/types/Project'
import type {Crumb} from '~/types/Article'
import {MdPreview} from '~/utils/mdEditor'

definePageMeta({layout: 'page'})

const route = useRoute()
const supabase = useSupabaseClient()

const slug = route.params.slug as string

const {
  data: project,
} = await useAsyncData<ProjectDetail | null>(`project-${slug}`, async () => {
  const {data, error} = await supabase
      .from('projects')
      .select(`
        id, name, slug, description, summary, image_url, year,
        companies(name),
        project_skills(skills(id, name, icon))
      `)
      .eq('slug', slug)
      .maybeSingle()
  if (error) throw error
  if (!data) throw createError({statusCode: 404, message: 'Project not found'})
  return data as ProjectDetail | null
})

const heroImageUrl = computed<string | null>(() => {
  const path = project.value?.image_url
  if (!path) return null
  if (path.startsWith('http://') || path.startsWith('https://')) return path
  return supabase.storage.from('images').getPublicUrl(path).data.publicUrl
})

usePageSeo({
  title: () => project.value?.name,
  description: () => {
    if (project.value?.summary) return project.value.summary
    const firstPara = project.value?.description?.split('\n').find(line => line.trim() && !line.startsWith('#'))
    return firstPara?.replace(/[*_`[\]]/g, '').substring(0, 160) ?? undefined
  },
  image: () => heroImageUrl.value ?? undefined,
})

const mdTheme = useMdEditorTheme()

const breadcrumbs = computed<Crumb[]>(() => {
  if (!project.value) return []
  return [
    {label: 'Projects', route: '/projects'},
    {label: project.value.name},
  ]
})
</script>

<template>
  <div>
    <article v-if="project" class="flex flex-col gap-6">

      <breadcrumb :breadcrumbs="breadcrumbs"/>

      <!-- Hero image
           With image on mobile: tall block, title overlaid at bottom with scrim
           With image on desktop (md+): shorter banner, no overlay, title lives below
           No image: skip entirely, title renders in header below -->
      <div v-if="heroImageUrl" class="relative w-full rounded-xl overflow-hidden min-h-64">
        <img
            :src="heroImageUrl"
            :alt="project.name"
            class="absolute inset-0 w-full h-full object-cover md:relative md:inset-auto md:h-56 md:w-full"
        />
        <div class="md:hidden absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"/>
        <div class="md:hidden absolute bottom-0 left-0 right-0 p-6">
          <h1 class="text-2xl font-semibold text-white leading-snug">{{ project.name }}</h1>
        </div>
      </div>

      <header class="flex flex-col gap-4">

        <!-- Title + edit: hidden on mobile when hero image exists (title is in the overlay instead) -->
        <div :class="heroImageUrl ? 'hidden md:flex' : 'flex'" class="justify-between items-start gap-4">
          <h1 class="text-3xl font-bold">{{ project.name }}</h1>
          <div class="shrink-0 pt-1">
            <project-admin-edit-button :project-id="project.id"/>
          </div>
        </div>

        <!-- Edit button on mobile when image exists (title is in overlay, edit button needs its own row) -->
        <div v-if="heroImageUrl" class="md:hidden flex justify-end">
          <project-admin-edit-button :project-id="project.id"/>
        </div>

        <!-- Company + year -->
        <div v-if="project.companies || project.year" class="flex items-center gap-2 text-sm">
          <span v-if="project.companies" class="font-semibold text-surface-800 dark:text-surface-200">{{ project.companies.name }}</span>
          <span v-if="project.companies && project.year" class="text-surface-400 dark:text-surface-600">·</span>
          <span v-if="project.year" class="text-surface-600 dark:text-surface-400">{{ project.year }}</span>
        </div>

        <!-- Skills -->
        <div v-if="project.project_skills?.length" class="flex flex-wrap gap-2">
          <span
              v-for="skillLink in project.project_skills"
              :key="skillLink.skills.id"
              class="flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-full bg-surface-100 text-surface-700 dark:bg-surface-800 dark:text-surface-300 leading-none"
          >
            <icon v-if="skillLink.skills.icon" :name="skillLink.skills.icon" class="w-4 h-4 shrink-0"/>
            {{ skillLink.skills.name }}
          </span>
        </div>

      </header>

      <div class="md-content-preview">
        <client-only>
          <md-preview
              editor-id="project-detail"
              language="en-US"
              :theme="mdTheme"
              :model-value="project.description"
          />
        </client-only>
      </div>

    </article>
  </div>
</template>
