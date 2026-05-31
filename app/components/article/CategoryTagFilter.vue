<script lang="ts" setup>
import type { ArticleCategory, ArticleTag } from '#shared/types/Articles'

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
  <div>
    <div class="flex flex-wrap gap-2 mb-2">
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
