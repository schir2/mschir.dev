<script lang="ts" setup>
import type { ArticleCardItem, ArticleSeriesSummary } from '#shared/types/Article'
import type { ArticleCategory } from '#shared/types/ArticleCategory'

definePageMeta({title: 'Articles', layout: 'page'})

usePageSeo({
  title: 'Articles',
  description: 'Articles on software development, systems architecture, API integrations, and technology by Marek Schir.',
})

const supabase = useSupabaseClient()

const articleCardSelect = 'id, title, slug, summary, published_at, image_url, series_id, series_sequence_number, article_categories(name, slug, color, image_url), article_tags_links(article_tags(name, slug, icon)), article_series(title, slug, image_url), featured_articles(id, featured_reason)'

const {
  data: featuredArticles,
  error: featuredError,
  pending: featuredPending,
} = useAsyncData<ArticleCardItem[]>('featured-articles', async () => {
  const {data, error} = await supabase
      .from('featured_articles')
      .select(`article_id, articles(${articleCardSelect})`)
      .limit(3)
  if (error) throw error
  return (data ?? []).map((row: any) => row.articles).filter(Boolean) as ArticleCardItem[]
}, {lazy: true})

const featuredIds = computed(() => (featuredArticles.value ?? []).map((article) => article.id))

const {
  data: recentArticles,
  error: recentError,
  pending: recentPending,
} = useAsyncData<ArticleCardItem[]>('recent-articles', async () => {
  const {data, error} = await supabase
      .from('articles')
      .select(articleCardSelect)
      .not('published_at', 'is', null)
      .is('archived_at', null)
      .order('published_at', {ascending: false})
      .limit(10)
  if (error) throw error
  const allRecent = (data ?? []) as ArticleCardItem[]
  const excluded = new Set(featuredIds.value)
  return allRecent.filter((article) => !excluded.has(article.id)).slice(0, 5)
}, {lazy: true, watch: [featuredIds]})

const {
  data: seriesList,
  error: seriesError,
  pending: seriesPending,
} = useAsyncData<ArticleSeriesSummary[]>('article-series', async () => {
  const {data, error} = await supabase
      .from('article_series')
      .select('id, title, slug, description, image_url, articles(id, published_at)')
  if (error) throw error
  return (data ?? [])
      .map((seriesRow: any) => ({
        id: seriesRow.id,
        title: seriesRow.title,
        slug: seriesRow.slug,
        description: seriesRow.description,
        image_url: seriesRow.image_url,
        article_count: (seriesRow.articles ?? []).filter((article: any) => article.published_at !== null).length,
      }))
      .filter((series: ArticleSeriesSummary) => series.article_count > 0) as ArticleSeriesSummary[]
}, {lazy: true})

const {
  data: categories,
  error: categoriesError,
  pending: categoriesPending,
} = useAsyncData<Pick<ArticleCategory, 'name' | 'slug'>[]>('article-categories', async () => {
  const {data, error} = await supabase
      .from('article_categories')
      .select('name, slug')
      .order('name')
  if (error) throw error
  return (data ?? []) as Pick<ArticleCategory, 'name' | 'slug'>[]
}, {lazy: true})
</script>

<template>
  <div class="flex flex-col gap-8">
    <div class="flex items-center justify-between">
      <h1 class="text-4xl font-bold">Articles</h1>
      <nuxt-link to="/articles/browse" class="text-primary text-sm hover:underline">Browse all articles</nuxt-link>
    </div>
    <section v-if="featuredPending || (featuredArticles && featuredArticles.length > 0)" class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Featured Articles</h2>
      <p-progress-spinner v-if="featuredPending"/>
      <p v-else-if="featuredError">{{ featuredError.message }}</p>
      <div v-else class="flex flex-col gap-4">
        <article-card
            v-for="article in featuredArticles"
            :key="article.id"
            :article="article"
        />
      </div>
    </section>

    <section class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Recent Articles</h2>
      <p-progress-spinner v-if="recentPending"/>
      <p v-else-if="recentError">{{ recentError.message }}</p>
      <div v-else class="flex flex-col gap-4">
        <article-card
            v-for="article in recentArticles ?? []"
            :key="article.id"
            :article="article"
        />
      </div>
    </section>

    <section v-if="seriesPending || (seriesList && seriesList.length > 0)" class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Series</h2>
      <p-progress-spinner v-if="seriesPending"/>
      <p v-else-if="seriesError">{{ seriesError.message }}</p>
      <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <article-series-card
            v-for="series in seriesList"
            :key="series.id"
            :series="series"
        />
      </div>
    </section>

    <section class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Browse by Category</h2>
      <p-progress-spinner v-if="categoriesPending"/>
      <p v-else-if="categoriesError">{{ categoriesError.message }}</p>
      <div v-else class="flex flex-wrap gap-2">
        <nuxt-link
            v-for="category in categories ?? []"
            :key="category.slug"
            :to="`/articles/browse?category=${category.slug}`"
            class="inline-flex items-center px-3 py-1 rounded-full border border-surface-600 text-sm hover:border-primary hover:text-primary transition-colors"
        >
          {{ category.name }}
        </nuxt-link>
      </div>
    </section>
  </div>
</template>
