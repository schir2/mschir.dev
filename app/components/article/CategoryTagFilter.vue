<script lang="ts" setup>
import type { ArticleTag } from '#shared/types/Article'
import type { ArticleCategory } from '#shared/types/ArticleCategory'

defineProps<{
  categories: ArticleCategory[]
  tags: ArticleTag[]
  modelCategory: string | null
  modelTags: string[]
}>()

defineEmits<{
  'update:modelCategory': [slug: string | null]
  'update:modelTags': [slugs: string[]]
}>()
</script>

<template>
  <div class="flex flex-col gap-2">
    <div class="flex flex-wrap gap-2">
      <button
        v-for="category in categories"
        :key="category.slug"
        type="button"
        @click="$emit('update:modelCategory', modelCategory === category.slug ? null : category.slug)"
      >
        <p-chip :label="category.name" />
      </button>
    </div>
    <div class="flex flex-wrap gap-2">
      <button
        v-for="tag in tags"
        :key="tag.slug"
        type="button"
        @click="$emit('update:modelTags', modelTags.includes(tag.slug) ? modelTags.filter(selectedSlug => selectedSlug !== tag.slug) : [...modelTags, tag.slug])"
      >
        <p-chip :label="tag.name" />
      </button>
    </div>
  </div>
</template>
