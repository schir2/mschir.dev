<script lang="ts" setup>
import type { ArticleSeriesSummary } from '#shared/types/Article'

const props = defineProps<{ series: ArticleSeriesSummary }>()
</script>

<template>
  <p-card>
    <template #title>
      <nuxt-link :to="`/articles/series/${props.series.slug}`" class="hover:text-primary transition-colors">
        {{ props.series.title }}
      </nuxt-link>
    </template>
    <template #subtitle>
      <p-tag severity="secondary" :value="`${props.series.article_count} articles`" />
    </template>
    <template #content>
      <p class="text-surface-300 text-sm">{{ props.series.description }}</p>
    </template>
  </p-card>
</template>
