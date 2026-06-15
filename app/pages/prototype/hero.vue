<script lang="ts" setup>
definePageMeta({ robots: false })

type OverlayMode = 'none' | 'dark' | 'gradient'

const { data: heroFiles } = await useFetch<string[]>('/api/heroes')
const currentIndex = ref(0)
const overlayMode = ref<OverlayMode>('dark')

const currentFilename = computed(() => heroFiles.value?.[currentIndex.value] ?? '')
const currentUrl = computed(() => `/img/heroes/${encodeURIComponent(currentFilename.value)}`)

const heroStyle = computed(() => ({
  backgroundImage: currentFilename.value ? `url('${currentUrl.value}')` : undefined,
}))

const overlayClass = computed(() => {
  if (overlayMode.value === 'dark') return 'absolute inset-0 bg-black/40'
  if (overlayMode.value === 'gradient') return 'absolute inset-0 hero-gradient-overlay'
  return 'hidden'
})

function prev() {
  if (!heroFiles.value?.length) return
  currentIndex.value = (currentIndex.value - 1 + heroFiles.value.length) % heroFiles.value.length
}

function next() {
  if (!heroFiles.value?.length) return
  currentIndex.value = (currentIndex.value + 1) % heroFiles.value.length
}
</script>

<template>
  <div class="flex flex-col">

    <!-- Controls -->
    <div class="flex items-center justify-between gap-4 px-6 py-3 bg-surface-800 border-b border-surface-700 flex-wrap">
      <div class="flex items-center gap-2">
        <p-button text severity="secondary" aria-label="Previous" @click="prev">
          <template #icon><icon name="material-symbols:arrow-back" class="text-lg"/></template>
        </p-button>
        <span class="text-sm text-muted-color whitespace-nowrap">
          {{ currentIndex + 1 }} / {{ heroFiles?.length ?? 0 }}
        </span>
        <p-button text severity="secondary" aria-label="Next" @click="next">
          <template #icon><icon name="material-symbols:arrow-forward" class="text-lg"/></template>
        </p-button>
        <span class="text-sm text-muted-color truncate max-w-xs">{{ currentFilename }}</span>
      </div>

      <!-- Thumbnail strip -->
      <div class="flex gap-2">
        <button
          v-for="(file, index) in heroFiles"
          :key="file"
          class="w-14 h-9 rounded overflow-hidden border-2 transition-colors shrink-0"
          :class="index === currentIndex ? 'border-amber-500' : 'border-surface-600'"
          @click="currentIndex = index"
        >
          <img
            :src="`/img/heroes/${encodeURIComponent(file)}`"
            :alt="file"
            class="w-full h-full object-cover"
          />
        </button>
      </div>

      <!-- Overlay toggle -->
      <div class="flex items-center gap-2">
        <span class="text-xs text-muted-color uppercase tracking-widest">Overlay</span>
        <p-button
          size="small"
          :severity="overlayMode === 'none' ? 'primary' : 'secondary'"
          :outlined="overlayMode !== 'none'"
          label="None"
          @click="overlayMode = 'none'"
        />
        <p-button
          size="small"
          :severity="overlayMode === 'dark' ? 'primary' : 'secondary'"
          :outlined="overlayMode !== 'dark'"
          label="Dark"
          @click="overlayMode = 'dark'"
        />
        <p-button
          size="small"
          :severity="overlayMode === 'gradient' ? 'primary' : 'secondary'"
          :outlined="overlayMode !== 'gradient'"
          label="Gradient"
          @click="overlayMode = 'gradient'"
        />
      </div>
    </div>

    <!-- Hero preview -->
    <section
      class="relative flex flex-col items-center justify-center text-center gap-6 px-6 min-h-screen bg-cover bg-center"
      :style="heroStyle"
    >
      <div :class="overlayClass"/>

      <div class="relative z-10 flex flex-col items-center gap-2">
        <h1 class="text-6xl font-bold text-white">Marek Schir</h1>
        <p class="text-2xl text-white/80">Software Developer & Systems Architect</p>
      </div>
      <p class="relative z-10 text-xl max-w-2xl text-white/70">
        Building the software and systems that make businesses run better.
      </p>
      <div class="relative z-10 flex gap-4 flex-wrap justify-center">
        <p-button label="See My Work" outlined/>
        <p-button label="Get in Touch" class="btn-accent"/>
      </div>
    </section>
  </div>
</template>

<style scoped>
.hero-gradient-overlay {
  background: linear-gradient(135deg, color-mix(in srgb, var(--p-primary-950) 70%, transparent) 0%, color-mix(in srgb, var(--p-primary-800) 70%, transparent) 60%, color-mix(in srgb, var(--p-accent-800) 70%, transparent) 100%);
}
</style>
