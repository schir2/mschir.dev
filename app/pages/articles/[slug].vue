<script lang="ts" setup>
import type { ArticleDetail } from '#shared/types/Articles'

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
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
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
        <h1 class="text-3xl font-bold mb-4">{{ article.title }}</h1>
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

      <client-only>
        <!-- editorId "article-detail" is referenced by the TOC sidebar (MdCatalog) -->
        <md-preview
          editor-id="article-detail"
          :model-value="article.content"
        />
      </client-only>
    </article>
  </div>
</template>
