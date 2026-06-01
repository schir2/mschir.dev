<script lang="ts" setup>
defineProps<{
  crumbs: { label: string; to?: string }[]
  title: string
  description?: string
}>()
</script>

<template>
  <header class="flex flex-col gap-3">
    <article-breadcrumb :crumbs="crumbs" />
    <h1 class="text-4xl font-bold">{{ title }}</h1>
    <p v-if="description" class="text-color-secondary text-lg">{{ description }}</p>
  </header>
</template>
