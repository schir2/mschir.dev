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
    <div class="max-w-6xl mx-auto px-6">
      <slot />
    </div>
  </main>
</template>
