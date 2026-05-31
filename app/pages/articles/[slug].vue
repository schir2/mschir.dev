<script lang="ts" setup>
import type { ArticleDetail } from '#shared/types/Article'
import type { SeriesArticle } from '~/types/Article'

const route = useRoute()
const supabase = useSupabaseClient()

const slug = route.params.slug as string

const {
  data: article,
  pending: articleLoading,
} = await useAsyncData<ArticleDetail | null>(`article-${slug}`, async () => {
  const { data, error } = await supabase
    .from('articles')
    .select(`
      id, title, slug, content, image_url, published_at, archived_at,
      view_count, series_id, series_sequence_number,
      article_categories(name, slug),
      article_tags_links(article_tags(name, slug)),
      article_series(title, slug, description)
    `)
    .eq('slug', slug)
    .not('published_at', 'is', null)
    .maybeSingle()

  if (error) throw error
  return data
}, { lazy: true })

watchEffect(() => {
  if (!articleLoading.value && article.value === null) {
    throw createError({ statusCode: 404, message: 'Article not found' })
  }
})

const heroImageUrl = computed(() => {
  if (!article.value?.image_url) return null
  const { data } = supabase.storage.from('images').getPublicUrl(article.value.image_url)
  return data.publicUrl
})

const formattedPublishedAt = computed(() => {
  if (!article.value?.published_at) return null
  return new Date(article.value.published_at).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
})

const { data: seriesSiblings } = await useAsyncData<SeriesArticle[]>(
  `series-${slug}`,
  async () => {
    const seriesId = article.value?.series_id
    if (!seriesId) return []

    const { data, error } = await supabase
      .from('articles')
      .select('id, title, slug, series_sequence_number')
      .eq('series_id', seriesId)
      .not('published_at', 'is', null)
      .order('series_sequence_number')

    if (error) throw error
    return data ?? []
  },
  { lazy: true, watch: [() => article.value?.series_id] },
)

const mdTheme = useMdEditorTheme()

const { previousArticle, nextArticle, allArticles } = useSeriesNavigation(
  computed(() => ({
    id: article.value?.id ?? '',
    series_sequence_number: article.value?.series_sequence_number ?? null,
  })),
  computed(() => seriesSiblings.value ?? []),
)
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <article-toc-sidebar editor-id="article-detail" />

    <p-progress-spinner v-if="articleLoading" />
    <article v-else-if="article">
      <article-archived-banner :archived-at="article.archived_at" />

      <img
        v-if="heroImageUrl"
        :src="heroImageUrl"
        :alt="article.title"
        class="w-full rounded-lg mb-8 object-cover max-h-80"
      />

      <header class="mb-8">
        <div class="flex justify-between items-start mb-4">
          <h1 class="text-3xl font-bold">{{ article.title }}</h1>
          <article-admin-edit-button :article-id="article.id" />
        </div>
        <div class="flex flex-wrap gap-3 text-sm text-color-secondary items-center">
          <span v-if="article.article_categories">
            {{ article.article_categories.name }}
          </span>
          <span v-if="formattedPublishedAt">{{ formattedPublishedAt }}</span>
          <span>{{ article.view_count }} views</span>
          <span>Matthew Schiraldi</span>
        </div>
        <div v-if="article.article_tags_links?.length" class="flex flex-wrap gap-2 mt-3">
          <nuxt-link
            v-for="tagLink in article.article_tags_links"
            :key="tagLink.article_tags.slug"
            :to="`/articles/browse?tag=${tagLink.article_tags.slug}`"
          >
            <p-tag :value="tagLink.article_tags.name" />
          </nuxt-link>
        </div>
      </header>

      <article-series-panel
        v-if="article.article_series && allArticles.length > 1"
        :series="article.article_series"
        :all-articles="allArticles"
        :current-article-id="article.id"
      />

      <client-only>
        <!-- editorId "article-detail" is referenced by ArticleTocSidebar (MdCatalog) -->
        <md-preview
          editor-id="article-detail"
          language="en-US"
          :theme="mdTheme"
          :model-value="article.content"
        />
      </client-only>

      <article-series-prev-next
        v-if="article.series_id"
        :previous-article="previousArticle"
        :next-article="nextArticle"
      />
    </article>
  </div>
</template>
