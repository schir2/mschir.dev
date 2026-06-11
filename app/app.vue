<script lang="ts" setup>
import DynamicDialog from 'primevue/dynamicdialog'

const route = useRoute()

useHead(() => ({
  title: route.meta.title as string ?? null,
}))

useAnalyticsConsent()
</script>

<template>
  <layout-navbar />
  <p-toast position="top-center" />
  <p-confirm-dialog />
  <dynamic-dialog />
  <cookie-control />
  <div class="flex flex-col gap-16">
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
    <layout-footer />
  </div>
</template>
