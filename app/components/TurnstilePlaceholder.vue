<script lang="ts" setup>
const model = defineModel<string>({default: ''})

onMounted(() => {
    model.value = 'placeholder-token'
})
</script>

<template>
  <div class="flex items-center gap-3 border border-surface-700 rounded-md px-4 py-3 bg-surface-900 text-surface-400 text-sm">
    <i class="pi pi-shield"/>
    <span>CAPTCHA placeholder — Turnstile not configured</span>
  </div>
</template>
