<script lang="ts" setup>
import type { Crumb } from '~/types/Article'

const props = defineProps<{
  crumbs: Crumb[]
  title: string
  description?: string
}>()
</script>

<template>
  <header class="flex flex-col gap-4">
    <breadcrumb :breadcrumbs="crumbs"/>
    <h1 class="text-4xl font-bold">{{ title }}</h1>
    <p v-if="description" class="text-color-secondary text-lg">{{ description }}</p>
  </header>
</template>
