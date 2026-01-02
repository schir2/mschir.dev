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
    <app-navbar/>
    <dynamic-dialog/>
    <slot/>
  </main>
  <app-footer/>
</template>