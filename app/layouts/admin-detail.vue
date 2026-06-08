<script lang="ts" setup>
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
    <slot />
  </main>
</template>
