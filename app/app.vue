<script lang="ts" setup>
import DynamicDialog from 'primevue/dynamicdialog'

const route = useRoute()

useHead(() => ({
  title: route.meta.title as string ?? null,
}))
</script>

<template>
  <layout-navbar />
  <p-toast position="top-center" />
  <p-confirm-dialog />
  <dynamic-dialog />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
  <layout-footer />
</template>
