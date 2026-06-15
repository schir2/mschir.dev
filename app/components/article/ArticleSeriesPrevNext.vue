<script lang="ts" setup>
defineProps<{
  previousArticle?: { title: string; slug: string } | null
  nextArticle?: { title: string; slug: string } | null
}>()
</script>

<template>
  <nav class="flex flex-col sm:flex-row sm:items-start gap-4 pt-8 border-t border-surface-200 dark:border-surface-700">
    <nuxt-link
      v-if="previousArticle"
      :to="`/articles/${previousArticle.slug}`"
      class="flex flex-col gap-1 group"
    >
      <span class="text-xs uppercase tracking-widest text-muted-color">← Previous</span>
      <span class="text-sm font-medium group-hover:text-primary transition-colors">{{ previousArticle.title }}</span>
    </nuxt-link>
    <nuxt-link
      v-if="nextArticle"
      :to="`/articles/${nextArticle.slug}`"
      class="flex flex-col gap-1 group sm:text-right sm:ml-auto"
    >
      <span class="text-xs uppercase tracking-widest text-muted-color">Next →</span>
      <span class="text-sm font-medium group-hover:text-primary transition-colors">{{ nextArticle.title }}</span>
    </nuxt-link>
  </nav>
</template>
