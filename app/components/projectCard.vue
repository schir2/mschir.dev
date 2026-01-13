<script lang="ts" setup>


import type {Project} from "#shared/types/Projects";

interface Props {
  project: Project
}

const {project} = defineProps<Props>()
</script>
<template>
  <p-card>
    <template #title>{{ project.name }}</template>
    <template #content>{{ project.description }}</template>
  </p-card>
</template>