<script lang="ts" setup>
const props = defineProps<{
  variants: Array<{ key: string; label: string }>
}>()

const route = useRoute()
const router = useRouter()

const currentIndex = computed(() => {
  const index = props.variants.findIndex(v => v.key === (route.query.variant as string))
  return index >= 0 ? index : 0
})
const current = computed(() => props.variants[currentIndex.value])

function go(delta: number) {
  const next = props.variants[(currentIndex.value + delta + props.variants.length) % props.variants.length]
  router.replace({ query: { ...route.query, variant: next.key } })
}

function onKeydown(event: KeyboardEvent) {
  const target = event.target as HTMLElement
  if (['INPUT', 'TEXTAREA'].includes(target.tagName) || target.isContentEditable) return
  if (event.key === 'ArrowLeft') go(-1)
  if (event.key === 'ArrowRight') go(1)
}

onMounted(() => window.addEventListener('keydown', onKeydown))
onUnmounted(() => window.removeEventListener('keydown', onKeydown))
</script>

<template>
  <div class="fixed bottom-6 left-1/2 -translate-x-1/2 z-50 flex items-center gap-4 bg-surface-950 border border-surface-700 rounded-full px-6 py-3 shadow-2xl select-none">
    <button @click="go(-1)" class="text-muted-color hover:text-color transition-colors text-lg leading-none">←</button>
    <span class="text-sm font-medium text-color whitespace-nowrap">{{ current.key }} — {{ current.label }}</span>
    <button @click="go(1)" class="text-muted-color hover:text-color transition-colors text-lg leading-none">→</button>
  </div>
</template>
