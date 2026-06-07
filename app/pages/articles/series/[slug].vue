<script lang="ts" setup>
import type { ArticleCardItem } from '#shared/types/Article'
import type { ArticleSeries } from '#shared/types/ArticleSeries'

definePageMeta({ layout: 'page' })

const route = useRoute()
const supabase = useSupabaseClient()

const seriesSlug = route.params.slug as string

const {
  data: seriesData,
  pending: seriesPending,
  error: seriesError,
} = await useAsyncData<Pick<ArticleSeries, 'id' | 'title' | 'slug' | 'description'> | null>(
  `series-detail-${seriesSlug}`,
  async () => {
    const { data, error } = await supabase
      .from('article_series')
      .select('id, title, slug, description')
      .eq('slug', seriesSlug)
      .maybeSingle()
    if (error) throw error
    return data
  },
)

watchEffect(() => {
  if (!seriesPending.value && seriesData.value === null) {
    throw createError({ statusCode: 404, message: 'Series not found' })
  }
})

usePageSeo({
  title: () => seriesData.value?.title,
  description: () => seriesData.value?.description ?? undefined,
})

useSchemaOrg(computed(() => {
  if (!seriesData.value) return []
  return [
    defineBreadcrumb({
      itemListElement: [
        { name: 'Articles', item: '/articles' },
        { name: seriesData.value.title },
      ],
    }),
  ]
}))

const {
  data: articleList,
  pending: articlesPending,
  error: articlesError,
} = await useAsyncData<ArticleCardItem[]>(
  `series-articles-${seriesSlug}`,
  async () => {
    const seriesId = seriesData.value?.id
    if (!seriesId) return []

    const { data, error } = await supabase
      .from('articles')
      .select('id, title, slug, summary, published_at, image_url, series_id, series_sequence_number, article_categories(name, slug, color, image_url), article_tags_links(article_tags(name, slug, icon)), article_series(title, slug, image_url), featured_articles(id, featured_reason)')
      .eq('series_id', seriesId)
      .not('published_at', 'is', null)
      .is('archived_at', null)
      .order('series_sequence_number', { ascending: true })
    if (error) throw error
    return (data ?? []) as ArticleCardItem[]
  },
  { lazy: true, watch: [() => seriesData.value?.id] },
)
</script>

<template>
  <div class="flex flex-col gap-16">
    <p v-if="seriesError">{{ seriesError.message }}</p>
    <template v-else-if="seriesData">
      <article-page-header
        :crumbs="[{ label: 'Articles', route: '/articles' }, { label: seriesData.title }]"
        :title="seriesData.title"
        :description="seriesData.description ?? undefined"
      />

      <section class="flex flex-col gap-6">
        <h2 class="text-2xl font-bold">Articles in this Series</h2>
        <ol v-if="articlesPending" class="flex flex-col gap-4 list-none">
          <li v-for="n in 3" :key="n" class="flex gap-4 items-start">
            <div class="w-8 h-[28px] rounded bg-surface-700 animate-pulse shrink-0" />
            <article-card loading class="flex-1" />
          </li>
        </ol>
        <p v-else-if="articlesError">{{ articlesError.message }}</p>
        <p v-else-if="!articleList || articleList.length === 0" class="text-color-secondary">
          No published articles in this series yet.
        </p>
        <ol v-else class="flex flex-col gap-4 list-none">
          <li
            v-for="seriesArticle in articleList"
            :key="seriesArticle.id"
            class="flex gap-4 items-start"
          >
            <span class="text-2xl font-bold text-color-secondary min-w-8 text-right shrink-0">
              {{ seriesArticle.series_sequence_number }}
            </span>
            <article-card :article="seriesArticle" class="flex-1" />
          </li>
        </ol>
      </section>
    </template>
  </div>
</template>
