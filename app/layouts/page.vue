<script lang="ts" setup>
import DynamicDialog from 'primevue/dynamicdialog'

const route = useRoute()

useHead(() => ({
  title: route.meta.title as string ?? null,
}))
</script>

<template>
  <main class="min-h-nav-offset">
    <p-toast position="top-center" />
    <layout-navbar />
    <dynamic-dialog />
    <div class="max-w-4xl mx-auto px-6 pt-6 pb-8">
      <slot />
    </div>
  </main>
  <layout-footer />
</template>
