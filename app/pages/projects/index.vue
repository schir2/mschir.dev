<script setup lang="ts">
import type {ProjectCardItem, ProjectWithSkills} from '#shared/types/Project'

definePageMeta({title: 'Projects', layout: 'page'})

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
    {lazy: true}
)

const detailedProjects = computed<ProjectCardItem[]>(() =>
    (projects.value ?? [])
        .filter(project => project.description)
        .map(project => ({
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

const otherProjects = computed<ProjectWithSkills[]>(() =>
    (projects.value ?? []).filter(project => !project.description)
)
</script>

<template>
  <section class="flex flex-col gap-6">
    <h1>Projects</h1>
    <p v-if="projectsError" class="text-red-400">{{ projectsError.message }}</p>
    <div v-else-if="projectsLoading" class="flex flex-col gap-4">
      <project-card v-for="n in 3" :key="n" loading/>
    </div>
    <template v-else>
      <div class="flex flex-col gap-4">
        <nuxt-link
            v-for="project in detailedProjects"
            :key="project.id"
            :to="`/projects/${project.slug}`"
            class="block"
        >
          <project-card :project="project"/>
        </nuxt-link>
      </div>

      <div v-if="otherProjects.length > 0" class="flex flex-col gap-4">
        <h2>Other Work</h2>
        <div class="flex flex-col">
          <template v-for="(project, index) in otherProjects" :key="project.id">
            <p-divider v-if="index > 0" class="my-0"/>
            <div class="flex items-center gap-4 py-3">
              <div class="flex flex-col gap-1 flex-1 min-w-0">
                <span class="font-semibold leading-snug">{{ project.name }}</span>
                <span class="text-xs text-muted-color">
                  {{ project.companies ? `${project.companies.name} · ` : '' }}{{ project.year }}
                </span>
              </div>
              <div class="flex flex-wrap items-center gap-2">
                <span
                    v-for="skillLink in project.project_skills.slice(0, 5)"
                    :key="skillLink.skills.id"
                    class="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-surface-100 text-surface-700 dark:bg-surface-800 dark:text-surface-300 leading-none"
                >
                  <icon v-if="skillLink.skills.icon" :name="skillLink.skills.icon" class="w-4 h-4 shrink-0"/>
                  {{ skillLink.skills.name }}
                </span>
                <span
                    v-if="project.project_skills.length > 5"
                    class="text-xs px-2.5 py-1 rounded-full bg-surface-100 text-surface-600 dark:bg-surface-800 dark:text-surface-500 leading-none"
                >
                  +{{ project.project_skills.length - 5 }}
                </span>
              </div>
            </div>
          </template>
        </div>
      </div>
    </template>
  </section>
</template>
