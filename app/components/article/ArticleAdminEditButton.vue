<script lang="ts" setup>
defineProps<{
  articleId: string
}>()

const user = useSupabaseUser()
const isAdmin = computed(() => user.value?.app_metadata?.role === 'admin')
</script>

<template>
  <nuxt-link v-if="isAdmin" :to="`/admin/articles/${articleId}`">
    <p-button label="Edit" icon="pi pi-pencil" size="small" />
  </nuxt-link>
</template>
