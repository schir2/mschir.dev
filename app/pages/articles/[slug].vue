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
    .select('id, title, content, created_at, archived_at, article_categories(name)')
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
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <p-progress-spinner v-if="articleLoading" />
    <article v-else-if="article">
      <article-archived-banner :archived-at="article.archived_at" />
      <header class="mb-8">
        <h1 class="text-3xl font-bold mb-2">{{ article.title }}</h1>
        <div class="flex gap-4 text-sm text-color-secondary">
          <span v-if="article.article_categories">{{ article.article_categories.name }}</span>
          <span>{{ new Date(article.created_at).toLocaleDateString() }}</span>
        </div>
      </header>
      <client-only>
        <md-preview
          id="article-preview"
          :model-value="article.content"
        />
      </client-only>
    </article>
  </div>
</template>
