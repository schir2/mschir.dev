<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'Edit Article' })

const route = useRoute()
const articleId = route.params.id as string
</script>

<template>
  <article-editor :article-id="articleId" />
</template>
