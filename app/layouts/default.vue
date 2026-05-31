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
    <p-toast position="top-center"/>
    <layout-navbar/>
    <dynamic-dialog/>
    <slot/>
  </main>
  <layout-footer/>
</template>

<style>
.page-enter-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.page-leave-active {
  transition: opacity 0.2s ease;
}
.page-enter-from {
  opacity: 0;
  transform: scale(0.98);
}
.page-leave-to {
  opacity: 0;
}

@media (prefers-reduced-motion: reduce) {
  .page-enter-active,
  .page-leave-active {
    transition: opacity 0.15s ease;
  }
  .page-enter-from {
    transform: none;
  }
}
</style>