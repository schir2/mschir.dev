<script lang="ts" setup>
import type { ArticleSeriesSummary } from '#shared/types/Article'

const props = defineProps<{
  series?: ArticleSeriesSummary
  loading?: boolean
}>()
</script>

<template>
  <p-card>
    <template #title>
      <div v-if="loading" class="h-[18px] w-[70%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse" />
      <nuxt-link v-else-if="series" :to="`/articles/series/${series.slug}`" class="hover:text-primary transition-colors">
        {{ series.title }}
      </nuxt-link>
    </template>
    <template #subtitle>
      <div v-if="loading" class="h-[22px] w-[80px] rounded-full bg-surface-200 dark:bg-surface-700 animate-pulse mt-1" />
      <p-tag v-else-if="series" severity="secondary" :value="`${series.article_count} articles`" />
    </template>
    <template #content>
      <div v-if="loading" class="flex flex-col gap-2 mt-1">
        <div class="h-[13px] w-full rounded bg-surface-200 dark:bg-surface-700 animate-pulse" />
        <div class="h-[13px] w-[75%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse" />
      </div>
      <p v-else-if="series" class="text-surface-700 dark:text-surface-300 text-sm">{{ series.description }}</p>
    </template>
  </p-card>
</template>
