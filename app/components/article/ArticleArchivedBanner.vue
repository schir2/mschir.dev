<script lang="ts" setup>
defineProps<{
  archivedAt: string | null
}>()
</script>

<template>
  <div v-if="archivedAt" role="alert">
    This article has been archived and may be outdated.
  </div>
</template>
