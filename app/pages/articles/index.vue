<script lang="ts" setup>
import type { ArticleListItem } from '#shared/types/Articles'

const supabase = useSupabaseClient()

const {
  data: articles,
  error: articlesError,
  pending: articlesLoading,
} = await useAsyncData<ArticleListItem[]>('articles', async () => {
  const { data, error } = await supabase
    .from('articles')
    .select('id, title, slug, author, created_at, image_url, article_topics(name, slug)')
    .eq('is_published', true)
    .order('created_at', { ascending: false })
  if (error) throw error
  return data as ArticleListItem[]
}, { lazy: true })
</script>

<template>
  <section>
    <p-progress-spinner v-if="articlesLoading" />Let's go with the drop down.
    <p v-else-if="articlesError">{{ articlesError.message }}</p>
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <p-card v-for="article in articles ?? []" :key="article.id">
        <template v-if="article.image_url" #header>
          <img :src="article.image_url" :alt="article.title" class="w-full object-cover" />
        </template>
        <template #title>
          <NuxtLink :to="`/articles/${article.slug}`">{{ article.title }}</NuxtLink>
        </template>
        <template v-if="article.article_topics" #subtitle>
          {{ article.article_topics.name }}
        </template>
        <template #content>
          <div class="flex justify-between text-sm">
            <span>{{ article.author }}</span>
            <span>{{ new Date(article.created_at).toLocaleDateString() }}</span>
          </div>
        </template>
      </p-card>
    </div>
  </section>
</template>