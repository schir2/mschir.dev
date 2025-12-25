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
  <main class="space-y-4 bg-background text-foreground dark min-h-screen">
    <app-navbar />
    <dynamic-dialog/>
    <app-header />
    <slot />
    <app-footer />
  </main>
</template>