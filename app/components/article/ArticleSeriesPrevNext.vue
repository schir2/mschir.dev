<script lang="ts" setup>
defineProps<{
  previousArticle?: { title: string; slug: string } | null
  nextArticle?: { title: string; slug: string } | null
}>()
</script>

<template>
  <footer class="flex justify-between mt-12 pt-6 border-t border-surface-200">
    <nuxt-link
      v-if="previousArticle"
      :to="`/articles/${previousArticle.slug}`"
      class="flex items-center gap-2 hover:underline"
    >
      <span>← {{ previousArticle.title }}</span>
    </nuxt-link>
    <span v-else />
    <nuxt-link
      v-if="nextArticle"
      :to="`/articles/${nextArticle.slug}`"
      class="flex items-center gap-2 hover:underline"
    >
      <span>{{ nextArticle.title }} →</span>
    </nuxt-link>
    <span v-else />
  </footer>
</template>
