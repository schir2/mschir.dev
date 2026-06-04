<script lang="ts" setup>
import DynamicDialog from 'primevue/dynamicdialog'

const route = useRoute()

useHead(() => ({
  title: route.meta.title as string ?? null,
}))
</script>
<template>
  <main class="min-h-nav-offset">
    <p-toast position="top-center"/>
    <layout-navbar/>
    <dynamic-dialog/>
    <slot/>
  </main>
  <layout-footer/>
</template>
