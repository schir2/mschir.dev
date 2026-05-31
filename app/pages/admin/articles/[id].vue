<script lang="ts" setup>
const route = useRoute()
const articleId = route.params.id as string
</script>

<template>
  <article-editor :article-id="articleId" />
</template>
