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
  <div>
    <app-navbar />
    <dynamic-dialog/>
    <app-header />
    <slot />
    <app-footer />
  </div>
</template>