<script lang="ts" setup>
const route = useRoute()
const projectId = route.params.id as string
</script>

<template>
  <project-editor :project-id="projectId" />
</template>
