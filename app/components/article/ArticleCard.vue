<script lang="ts" setup>
import type { ArticleCardItem } from '#shared/types/Articles'

const props = defineProps<{
  article: ArticleCardItem
  size?: 'featured' | 'default'
}>()

const visibleTags = computed(() => props.article.article_tags_links.slice(0, 3))

const formattedDate = computed(() =>
  props.article.published_at
    ? new Date(props.article.published_at).toLocaleDateString()
    : ''
)
</script>

<template>
  <p-card :class="size === 'featured' ? 'h-full' : ''">
    <template v-if="article.image_url" #header>
      <img :src="article.image_url" :alt="article.title" class="w-full h-48 object-cover" />
    </template>
    <template #title>
      <nuxt-link :to="`/articles/${article.slug}`" class="hover:text-primary transition-colors">
        {{ article.title }}
      </nuxt-link>
    </template>
    <template #subtitle>
      <nuxt-link
        v-if="article.article_categories"
        :to="`/articles/browse?category=${article.article_categories.slug}`"
      >
        <p-chip :label="article.article_categories.name" icon="pi pi-folder" class="cursor-pointer" />
      </nuxt-link>
    </template>
    <template #content>
      <div class="flex flex-wrap gap-1 mb-3">
        <nuxt-link
          v-for="tagLink in visibleTags"
          :key="tagLink.article_tags.slug"
          :to="`/articles/browse?tag=${tagLink.article_tags.slug}`"
        >
          <p-tag :value="tagLink.article_tags.name" severity="secondary" class="cursor-pointer" />
        </nuxt-link>
      </div>
      <div class="flex items-center justify-between text-sm text-surface-400 mt-2">
        <span>{{ formattedDate }}</span>
        <nuxt-link
          v-if="article.article_series"
          :to="`/articles/series/${article.article_series.slug}`"
        >
          <p-tag :value="article.article_series.title" severity="info" icon="pi pi-list" class="cursor-pointer" />
        </nuxt-link>
      </div>
    </template>
  </p-card>
</template>
