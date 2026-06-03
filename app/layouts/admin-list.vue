<script lang="ts" setup>
import DynamicDialog from 'primevue/dynamicdialog'

const route = useRoute()
const config = useRuntimeConfig()

const pageTitle = computed(() =>
  route.meta.title ?? config.public.defaultTitle
)

useHead(() => ({
  title: pageTitle.value
}))
</script>

<template>
  <main class="min-h-nav-offset">
    <p-toast position="top-center" />
    <p-confirm-dialog />
    <layout-navbar />
    <dynamic-dialog />
    <div class="max-w-6xl mx-auto px-6">
      <slot />
    </div>
  </main>
  <layout-footer />
</template>
