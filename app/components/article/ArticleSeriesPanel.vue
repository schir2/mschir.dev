<script lang="ts" setup>
defineProps<{
  series: { title: string; slug: string; description: string | null }
  allArticles: Array<{ id: string; title: string; slug: string; series_sequence_number: number | null }>
  currentArticleId: string
}>()
</script>

<template>
  <aside class="border border-surface-200 rounded-lg p-4 mb-8">
    <h2 class="font-semibold text-lg mb-1">Series: {{ series.title }}</h2>
    <p v-if="series.description" class="text-sm text-color-secondary mb-3">{{ series.description }}</p>
    <ol class="space-y-1">
      <li v-for="seriesArticle in allArticles" :key="seriesArticle.id">
        <nuxt-link
          :to="`/articles/${seriesArticle.slug}`"
          :class="seriesArticle.id === currentArticleId ? 'font-bold' : 'hover:underline'"
          class="text-sm"
        >
          {{ seriesArticle.series_sequence_number }}. {{ seriesArticle.title }}
        </nuxt-link>
      </li>
    </ol>
  </aside>
</template>
