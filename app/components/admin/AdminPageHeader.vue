<script lang="ts" setup>
const route = useRoute()
const title = computed<string | undefined>(() => route.meta.title as string | undefined)
</script>

<template>
  <div class="flex justify-between items-center pt-6 pb-4 border-b border-surface-700">
    <h1 class="text-3xl">{{ title }}</h1>
    <slot name="actions" />
  </div>
</template>
