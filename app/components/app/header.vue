<script lang="ts" setup>

interface Props {
  title: string
}

const props = defineProps<Props>()
</script>
<template>
  <header :title="props.title">
    <h1>{{ props.title }}</h1>
  </header>
</template>