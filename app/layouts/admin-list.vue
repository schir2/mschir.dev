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
  <main class="min-h-nav-offset flex">
    <admin-sidebar />
    <div class="flex-1 min-w-0 px-6">
      <slot />
    </div>
  </main>
</template>
