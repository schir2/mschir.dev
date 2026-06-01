<script lang="ts" setup>
import type { Crumb } from '~/types/Article'

const props = defineProps<{
  crumbs: Crumb[]
  title: string
  description?: string
}>()

const model = computed(() =>
    props.crumbs.map((crumb, index) => ({
      label: crumb.label,
      to: crumb.to,
      disabled: index === props.crumbs.length - 1,
    })),
)
</script>

<template>
  <header class="flex flex-col gap-3">
    <p-breadcrumb :model="model"/>
    <h1 class="text-4xl font-bold">{{ title }}</h1>
    <p v-if="description" class="text-color-secondary text-lg">{{ description }}</p>
  </header>
</template>
