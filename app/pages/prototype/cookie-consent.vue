<script lang="ts" setup>
// PROTOTYPE — cookie consent banner variants. Delete when design is chosen.
// Question: which banner layout to use for the cookie consent implementation?
// Variants: A = slim bar, B = stacked, C = card with icon (PrimeVue p-card)

definePageMeta({ title: 'Prototype: Cookie Consent', layout: 'page' })

const route = useRoute()
const showBanner = ref(true)
const currentVariant = computed(() => (route.query.variant as string) ?? 'A')

const variants = [
  { key: 'A', label: 'Slim bar' },
  { key: 'B', label: 'Stacked' },
  { key: 'C', label: 'Card with icon' },
]

watch(currentVariant, () => { showBanner.value = true })

function accept() { showBanner.value = false }
function decline() { showBanner.value = false }
</script>

<template>
  <div class="flex flex-col gap-8">

    <div class="flex flex-col gap-2">
      <h1>Cookie Consent Prototype</h1>
      <p class="text-muted-color">
        Use ← → arrow keys or the switcher bar to cycle variants. Accept or decline to dismiss
        the banner. The "Cookie Preferences" link in the real footer (below) will re-open it.
      </p>
    </div>

    <p-card>
      <template #content>
        <div class="flex flex-col gap-2">
          <p class="text-sm font-semibold">Current variant: {{ currentVariant }}</p>
          <p class="text-sm text-muted-color">Banner visible: {{ showBanner }}</p>
        </div>
      </template>
    </p-card>

  </div>

  <!-- Variant A: slim single-line bar -->
  <transition name="slide-up">
    <div
      v-if="showBanner && currentVariant === 'A'"
      class="fixed left-0 right-0 bottom-20 z-40 border-t border-surface-700 bg-surface-900"
    >
      <div class="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between gap-8">
        <p class="text-sm text-muted-color">
          This site uses Google Analytics to understand how content is being used. No advertising cookies are set.
        </p>
        <div class="flex gap-4 flex-shrink-0">
          <p-button label="Accept" severity="success" size="small" @click="accept" />
          <p-button label="Decline" severity="secondary" outlined size="small" @click="decline" />
        </div>
      </div>
    </div>
  </transition>

  <!-- Variant B: stacked two-line -->
  <transition name="slide-up">
    <div
      v-if="showBanner && currentVariant === 'B'"
      class="fixed left-0 right-0 bottom-20 z-40 border-t border-surface-700 bg-surface-900"
    >
      <div class="max-w-6xl mx-auto px-6 py-6 flex flex-col gap-4">
        <div class="flex flex-col gap-1">
          <p class="text-sm font-semibold text-color">We use cookies</p>
          <p class="text-sm text-muted-color">
            This site uses Google Analytics to understand which content is most useful.
            No advertising data is collected and no data is shared with third parties.
          </p>
        </div>
        <div class="flex justify-end gap-4">
          <p-button label="Decline" severity="secondary" outlined size="small" @click="decline" />
          <p-button label="Accept Analytics" severity="success" size="small" @click="accept" />
        </div>
      </div>
    </div>
  </transition>

  <!-- Variant C: p-card with cookie icon -->
  <transition name="slide-up">
    <div
      v-if="showBanner && currentVariant === 'C'"
      class="fixed left-0 right-0 bottom-20 z-40 px-6"
    >
      <div class="max-w-6xl mx-auto">
        <p-card class="border border-surface-700 rounded-b-none">
          <template #content>
            <div class="flex items-center gap-6">
              <icon name="mdi:cookie-outline" class="text-4xl text-accent-400 flex-shrink-0" />
              <div class="flex-1 flex flex-col gap-1">
                <p class="text-sm font-semibold text-color">Cookie notice</p>
                <p class="text-sm text-muted-color">
                  Google Analytics helps understand how visitors use this site. No ads, no cross-site tracking.
                </p>
              </div>
              <div class="flex gap-3 flex-shrink-0">
                <p-button label="Decline" severity="secondary" outlined size="small" @click="decline" />
                <p-button label="Accept" severity="success" size="small" @click="accept" />
              </div>
            </div>
          </template>
        </p-card>
      </div>
    </div>
  </transition>

  <prototype-switcher :variants="variants" />
</template>

<style scoped>
.slide-up-enter-active,
.slide-up-leave-active {
  transition: transform 0.2s ease, opacity 0.2s ease;
}
.slide-up-enter-from,
.slide-up-leave-to {
  transform: translateY(100%);
  opacity: 0;
}
</style>
