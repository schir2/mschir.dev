<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'Edit Project' })

const route = useRoute()
const projectId = route.params.id as string
</script>

<template>
  <project-editor :project-id="projectId" />
</template>
