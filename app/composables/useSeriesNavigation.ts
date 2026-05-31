import { type MaybeRef } from 'vue'
import type { SeriesArticle } from '~/types/Article'

type CurrentArticle = {
  id: string
  series_sequence_number: number | null
}

export function useSeriesNavigation(
  currentArticle: MaybeRef<CurrentArticle>,
  siblings: MaybeRef<SeriesArticle[]>,
) {
  const allArticles = computed(() =>
    [...toValue(siblings)].sort(
      (articleA, articleB) =>
        (articleA.series_sequence_number ?? 0) - (articleB.series_sequence_number ?? 0),
    ),
  )

  const currentIndex = computed(() =>
    allArticles.value.findIndex(article => article.id === toValue(currentArticle).id),
  )

  const previousArticle = computed(() =>
    currentIndex.value > 0 ? allArticles.value[currentIndex.value - 1] : null,
  )

  const nextArticle = computed(() =>
    currentIndex.value < allArticles.value.length - 1
      ? allArticles.value[currentIndex.value + 1]
      : null,
  )

  return { previousArticle, nextArticle, allArticles, currentIndex }
}