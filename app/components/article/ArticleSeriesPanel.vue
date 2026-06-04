<script lang="ts" setup>
defineProps<{
  series: { title: string; slug: string; description: string | null }
  allArticles: Array<{ id: string; title: string; slug: string; series_sequence_number: number | null }>
  currentArticleId: string
}>()
</script>

<template>
  <aside class="border border-surface-200 rounded-lg p-4 flex flex-col gap-4">
    <div class="flex flex-col gap-2">
      <h2 class="font-semibold text-lg">Series: {{ series.title }}</h2>
      <p v-if="series.description" class="text-sm text-color-secondary">{{ series.description }}</p>
    </div>
    <ol class="flex flex-col gap-2">
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
