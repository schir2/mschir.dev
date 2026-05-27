<script lang="ts" setup>
import type { ProjectWithSkills } from '#shared/types/Projects'

const supabase = useSupabaseClient()

const {
  data: projects,
  error: projectsError,
  pending: projectsLoading,
  refresh: projectsRefresh
} = await useAsyncData<ProjectWithSkills[]>('projects', async () => {
      await new Promise(resolve => setTimeout(resolve, 500))
      const {data, error} = await supabase
        .from('projects')
        .select('*, project_skills(skills(id, name, icon))')
        .order('year', {ascending: false})
      if (error) {
        throw error
      }
      return data as ProjectWithSkills[]
    },
    {
      lazy: true
    })

</script>
<template>
  <section>
    <h1 v-if="projectsError">{{ projectsError.message }}</h1>
    <p-progress-spinner v-else-if="projectsLoading"/>
    <project-timeline v-else :projects="projects ?? []"/>

  </section>
</template>
