<script lang="ts" setup>
defineProps<{
  projectId: string
}>()

const user = useSupabaseUser()
const isAdmin = computed(() => user.value?.app_metadata?.role === 'admin')
</script>

<template>
  <nuxt-link v-if="isAdmin" :to="`/admin/projects/${projectId}`">
    <p-button label="Edit" icon="pi pi-pencil" size="small" />
  </nuxt-link>
</template>
