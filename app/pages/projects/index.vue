<script setup lang="ts">
import type { ProjectWithSkills, ProjectCardItem } from '#shared/types/Project'

definePageMeta({ title: 'Projects', layout: 'page' })

usePageSeo({
  title: 'Projects',
  description: 'Projects built by Marek Schir — software applications, API integrations, field service management, and business automation.',
})

const supabase = useSupabaseClient()

const {
  data: projects,
  error: projectsError,
  pending: projectsLoading,
} = await useAsyncData<ProjectWithSkills[]>('projects', async () => {
      const {data, error} = await supabase
        .from('projects')
        .select('*, companies(name), project_skills(skills(id, name, icon))')
        .order('year', {ascending: false})
      if (error) throw error
      return data as ProjectWithSkills[]
    },
    { lazy: true }
)

const projectCards = computed<ProjectCardItem[]>(() =>
  (projects.value ?? []).map(project => ({
    id: project.id,
    name: project.name,
    year: project.year,
    summary: project.summary,
    slug: project.slug,
    image_url: project.image_url,
    companies: project.companies,
    project_skills: project.project_skills,
    tagline: null,
    featured: false,
  }))
)
</script>

<template>
  <section class="flex flex-col gap-6">
    <h1>Projects</h1>
    <p v-if="projectsError" class="text-red-400">{{ projectsError.message }}</p>
    <div v-else-if="projectsLoading" class="flex flex-col gap-4">
      <project-card v-for="n in 3" :key="n" loading />
    </div>
    <div v-else class="flex flex-col gap-4">
      <nuxt-link
        v-for="project in projectCards"
        :key="project.id"
        :to="`/projects/${project.slug}`"
        class="block"
      >
        <project-card :project="project"/>
      </nuxt-link>
    </div>
  </section>
</template>
