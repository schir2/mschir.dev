<!-- PROTOTYPE tool — do not ship. Gate with v-if="isDev" in parent. -->
<script lang="ts" setup>
const props = defineProps<{
  variants: Array<{ key: string; label: string }>
  current: string
}>()

const router = useRouter()

const currentIndex = computed(() =>
  props.variants.findIndex(variant => variant.key === props.current)
)

const currentLabel = computed(() => {
  const variant = props.variants[currentIndex.value]
  return variant ? `${variant.key} — ${variant.label}` : props.current
})

function goToIndex(index: number) {
  const wrappedIndex = ((index % props.variants.length) + props.variants.length) % props.variants.length
  router.replace({ query: { variant: props.variants[wrappedIndex].key } })
}

function onKeydown(event: KeyboardEvent) {
  const target = event.target as HTMLElement
  if (target instanceof HTMLInputElement || target instanceof HTMLTextAreaElement || target.isContentEditable) return
  if (event.key === 'ArrowLeft') goToIndex(currentIndex.value - 1)
  if (event.key === 'ArrowRight') goToIndex(currentIndex.value + 1)
}

onMounted(() => window.addEventListener('keydown', onKeydown))
onUnmounted(() => window.removeEventListener('keydown', onKeydown))
</script>

<template>
  <div
    class="fixed bottom-6 left-1/2 -translate-x-1/2 flex items-center gap-3 px-5 py-2 rounded-full z-50 shadow-lg"
    style="background: var(--p-surface-900); border: 1px solid var(--p-surface-600); color: var(--p-text-color)"
  >
    <button
      class="px-1 hover:opacity-70 transition-opacity text-lg leading-none"
      aria-label="Previous variant"
      @click="goToIndex(currentIndex - 1)"
    >←</button>
    <span class="text-sm font-mono whitespace-nowrap select-none">{{ currentLabel }}</span>
    <button
      class="px-1 hover:opacity-70 transition-opacity text-lg leading-none"
      aria-label="Next variant"
      @click="goToIndex(currentIndex + 1)"
    >→</button>
  </div>
</template>
