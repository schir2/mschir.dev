<script lang="ts" setup>
defineProps<{
  previousArticle: { title: string; slug: string } | null
  nextArticle: { title: string; slug: string } | null
}>()
</script>

<template>
  <nav class="flex items-start justify-between gap-4 pt-8 border-t border-surface-800">
    <nuxt-link
      v-if="previousArticle"
      :to="`/articles/${previousArticle.slug}`"
      class="flex flex-col gap-1 group max-w-xs"
    >
      <span class="text-xs uppercase tracking-widest text-muted-color">← Previous</span>
      <span class="text-sm font-medium group-hover:text-primary transition-colors">{{ previousArticle.title }}</span>
    </nuxt-link>
    <div v-else />
    <nuxt-link
      v-if="nextArticle"
      :to="`/articles/${nextArticle.slug}`"
      class="flex flex-col gap-1 group max-w-xs text-right"
    >
      <span class="text-xs uppercase tracking-widest text-muted-color">Next →</span>
      <span class="text-sm font-medium group-hover:text-primary transition-colors">{{ nextArticle.title }}</span>
    </nuxt-link>
    <div v-else />
  </nav>
</template>
