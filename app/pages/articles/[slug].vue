<script lang="ts" setup>
import type {ArticleDetail} from '#shared/types/Article'
import type {Crumb, SeriesArticle} from '~/types/Article'
import {formatArticleDate} from '~/utils/formatArticleDate'
import {MdPreview} from '~/utils/mdPreview'

definePageMeta({layout: 'page'})

const route = useRoute()
const supabase = useSupabaseClient()
const { resolveImageUrl } = useStorageUrl()

const slug = route.params.slug as string

const {
  data: article,
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
  if (!data) throw createError({statusCode: 404, message: 'Article not found'})
  return data
})

const heroImageUrl = computed(() => resolveImageUrl(article.value?.image_url ?? null))

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
  description: () => {
    if (article.value?.summary) return article.value.summary
    const firstPara = article.value?.content?.split('\n').find(line => line.trim() && !line.startsWith('#'))
    return firstPara?.replace(/[*_`[\]]/g, '').substring(0, 160) ?? undefined
  },
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

    <article v-if="article" class="flex flex-col gap-8">
      <breadcrumb :breadcrumbs="breadcrumbs"/>
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
        <div class="flex flex-col gap-1">
          <div class="flex justify-between items-start gap-4">
            <h1 class="text-3xl font-bold flex-1 min-w-0">{{ article.title }}</h1>
            <article-admin-edit-button :article-id="article.id"/>
          </div>
          <span v-if="article.article_series && allArticles.length > 1" class="text-xs uppercase tracking-widest font-medium text-muted-color">
            Part {{ article.series_sequence_number }} of {{ allArticles.length }} ·
            <nuxt-link
              :to="`/articles/series/${article.article_series.slug}`"
              class="hover:text-color transition-colors"
            >{{ article.article_series.title }}</nuxt-link>
          </span>
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
              class="flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-full bg-surface-100 text-surface-700 dark:bg-surface-800 dark:text-surface-300 leading-none hover:bg-surface-200 dark:hover:bg-surface-700 hover:text-surface-800 dark:hover:text-surface-100 transition-colors"
          >
            <icon v-if="tagLink.article_tags.icon" :name="tagLink.article_tags.icon" class="w-4 h-4 shrink-0"/>
            {{ tagLink.article_tags.name }}
          </nuxt-link>
        </div>
      </header>

      <article-series-nav
          v-if="article.article_series && allArticles.length > 1"
          :articles="allArticles"
          :current-article-id="article.id"
      />

      <client-only>
        <div class="md-content-preview">
          <md-preview
              editor-id="article-detail"
              language="en-US"
              :theme="mdTheme"
              :model-value="article.content"
          />
        </div>
      </client-only>

      <article-series-prev-next
          v-if="article.series_id"
          :previous-article="previousArticle"
          :next-article="nextArticle"
      />
    </article>
  </div>
</template>
