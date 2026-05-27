<script lang="ts" setup>

const supabase = useSupabaseClient()

const {
  data: projects,
  error: projectsError,
  pending: projectsLoading,
  refresh: projectsRefresh
} = await useAsyncData('projects', async () => {
      await new Promise(resolve => setTimeout(resolve, 500))
      const {data, error} = await supabase.from('projects').select('*').order('year', {ascending: false})
      if (error) {
        throw error
      }
      return data
    },
    {
      lazy: true
    })

</script>
<template>
  <section>
    <h1 v-if="projectsError">{{ projectsError.message }}</h1>
    <p-progress-spinner v-else-if="projectsLoading" />
    <project-card v-else v-for="project in projects" :project="project" :key="project"/>

  </section>
</template>
