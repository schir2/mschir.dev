<script lang="ts" setup>
import type {ArticleDetail} from '#shared/types/Article'
import type {Crumb, SeriesArticle} from '~/types/Article'
import {formatArticleDate} from '~/utils/formatArticleDate'

definePageMeta({layout: 'page'})

const route = useRoute()
const supabase = useSupabaseClient()

const slug = route.params.slug as string

const {
  data: article,
  pending: articleLoading,
} = await useAsyncData<ArticleDetail | null>(`article-${slug}`, async () => {
  const {data, error} = await supabase
      .from('articles')
      .select(`
      id, title, slug, summary, content, image_url, published_at, archived_at,
      view_count, series_id, series_sequence_number,
      article_categories(name, slug),
      article_tags_links(article_tags(name, slug, icon)),
      article_series(title, slug, description)
    `)
      .eq('slug', slug)
      .not('published_at', 'is', null)
      .maybeSingle()

  if (error) throw error
  return data
})

watchEffect(() => {
  if (!articleLoading.value && article.value === null) {
    throw createError({statusCode: 404, message: 'Article not found'})
  }
})

const heroImageUrl = computed(() => {
  if (!article.value?.image_url) return null
  const {data} = supabase.storage.from('images').getPublicUrl(article.value.image_url)
  return data.publicUrl
})

const formattedPublishedAt = computed(() => formatArticleDate(article.value?.published_at ?? null) || null)

const {data: seriesSiblings} = await useAsyncData<SeriesArticle[]>(
    `series-${slug}`,
    async () => {
      const seriesId = article.value?.series_id
      if (!seriesId) return []

      const {data, error} = await supabase
          .from('articles')
          .select('id, title, slug, series_sequence_number')
          .eq('series_id', seriesId)
          .not('published_at', 'is', null)
          .order('series_sequence_number')

      if (error) throw error
      return data ?? []
    },
    {lazy: true, watch: [() => article.value?.series_id]},
)

usePageSeo({
  title: () => article.value?.title,
  description: () => article.value?.summary ?? undefined,
  image: () => heroImageUrl.value ?? undefined,
  type: 'article',
  publishedAt: () => article.value?.published_at ?? undefined,
})

const mdTheme = useMdEditorTheme()

const breadcrumbs = computed<Crumb[]>(() => {
  if (!article.value) return []
  const crumbs: Crumb[] = [{label: 'Articles', route: '/articles'}]
  if (article.value.article_categories) {
    crumbs.push({
      label: article.value.article_categories.name,
      route: `/articles/browse?category=${article.value.article_categories.slug}`,
    })
  }
  if (article.value.article_series) {
    crumbs.push({
      label: article.value.article_series.title,
      route: `/articles/series/${article.value.article_series.slug}`,
    })
  }
  crumbs.push({label: article.value.title})
  return crumbs
})

useSchemaOrg(computed(() => {
  if (!article.value) return []
  return [
    defineArticle({
      '@type': 'BlogPosting',
      headline: article.value.title,
      description: article.value.summary ?? undefined,
      image: heroImageUrl.value ?? undefined,
      datePublished: article.value.published_at ?? undefined,
      author: [{ name: 'Marek Schir', url: '/about' }],
    }),
    defineBreadcrumb({
      itemListElement: breadcrumbs.value.map(crumb => ({
        name: crumb.label,
        ...(crumb.route ? { item: crumb.route } : {}),
      })),
    }),
  ]
}))

const {previousArticle, nextArticle, allArticles} = useSeriesNavigation(
    computed(() => ({
      id: article.value?.id ?? '',
      series_sequence_number: article.value?.series_sequence_number ?? null,
    })),
    computed(() => seriesSiblings.value ?? []),
)
</script>

<template>
  <div>

    <p-progress-spinner v-if="articleLoading"/>
    <article v-else-if="article" class="flex flex-col gap-8">
      <breadcrumb :model="breadcrumbs"/>
      <p-message v-if="article.archived_at" role="alert" severity="secondary">
        This article has been archived and may be outdated.
      </p-message>

      <img
          v-if="heroImageUrl"
          :src="heroImageUrl"
          :alt="article.title"
          class="w-full rounded-lg object-cover max-h-80"
      />

      <header class="flex flex-col gap-4">
        <div class="flex justify-between items-start">
          <h1 class="text-3xl font-bold">{{ article.title }}</h1>
          <article-admin-edit-button :article-id="article.id"/>
        </div>
        <div class="flex flex-wrap gap-4 text-sm text-color-secondary items-center">
          <span v-if="article.article_categories">
            {{ article.article_categories.name }}
          </span>
          <span v-if="formattedPublishedAt">{{ formattedPublishedAt }}</span>
          <span>{{ article.view_count }} views</span>
          <span>Marek Schir</span>
        </div>
        <div v-if="article.article_tags_links?.length" class="flex flex-wrap gap-2">
          <nuxt-link
              v-for="tagLink in article.article_tags_links"
              :key="tagLink.article_tags.slug"
              :to="`/articles/browse?tag=${tagLink.article_tags.slug}`"
              class="flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-full bg-surface-800 text-surface-300 leading-none hover:bg-surface-700 hover:text-surface-100 transition-colors"
          >
            <icon v-if="tagLink.article_tags.icon" :name="tagLink.article_tags.icon" class="w-4 h-4 shrink-0"/>
            {{ tagLink.article_tags.name }}
          </nuxt-link>
        </div>
      </header>

      <article-series-panel
          v-if="article.article_series && allArticles.length > 1"
          :series="article.article_series"
          :all-articles="allArticles"
          :current-article-id="article.id"
      />

      <div class="max-w-4xl mx-auto">
        <client-only>
          <!-- editorId "article-detail" is referenced by ArticleTocSidebar (MdCatalog) -->
          <div class="md-content-preview">
            <md-preview
                editor-id="article-detail"
                language="en-US"
                :theme="mdTheme"
                :model-value="article.content"
            />
          </div>
        </client-only>
      </div>

      <article-series-prev-next
          v-if="article.series_id"
          :previous-article="previousArticle"
          :next-article="nextArticle"
      />
    </article>
  </div>
</template>
