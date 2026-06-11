<script lang="ts" setup>
import type { SeriesArticle } from '~/types/Article'

const props = defineProps<{
  articles: SeriesArticle[]
  currentArticleId: string
}>()

const total = computed(() => props.articles.length)

const selectOptions = computed(() =>
  props.articles.map(article => ({
    label: `Part ${article.series_sequence_number} of ${total.value} — ${article.title}`,
    value: article.slug,
  }))
)

const currentSlug = computed(
  () => props.articles.find(article => article.id === props.currentArticleId)?.slug ?? null
)

const selectedSlug = ref<string | null>(currentSlug.value)

watch(currentSlug, (slug) => {
  selectedSlug.value = slug
})
</script>

<template>
  <p-select
    v-model="selectedSlug"
    :options="selectOptions"
    option-label="label"
    option-value="value"
    class="w-full"
    @change="navigateTo(`/articles/${selectedSlug}`)"
  />
</template>