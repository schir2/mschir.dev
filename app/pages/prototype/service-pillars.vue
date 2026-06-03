<script lang="ts" setup>
definePageMeta({ title: 'Prototype: Service Pillars', layout: 'page' })

const pillars = [
  {
    icon: 'material-symbols:hub',
    title: 'Integrations & APIs',
    description: 'Connecting your platforms, building the APIs that tie them together.',
  },
  {
    icon: 'material-symbols:code-blocks',
    title: 'Application Development',
    description: 'Custom software and legacy modernization for the way your business actually runs.',
  },
  {
    icon: 'material-symbols:smart-toy',
    title: 'AI & Automation',
    description: 'Workflow automation and AI-enriched pipelines that eliminate the manual work.',
  },
  {
    icon: 'material-symbols:cloud',
    title: 'Infrastructure & Cloud',
    description: 'Cloud architecture, networking, and security across AWS, Azure, Cloudflare, and more.',
  },
]
</script>

<template>
  <div class="flex flex-col gap-24 pb-24">

    <div>
      <h1 class="text-3xl mb-2">Service Pillars — Prototype</h1>
      <p class="text-muted-color">Three variants below, current layout shown first for reference.</p>
    </div>

    <!-- ── Current (reference) ─────────────────────────────────────── -->
    <section class="flex flex-col gap-6">
      <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Current (reference)</span>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <p-card v-for="pillar in pillars" :key="pillar.title">
          <template #title>
            <div class="flex flex-col items-start gap-2">
              <icon :name="pillar.icon" class="text-2xl text-primary"/>
              <span class="text-sm font-semibold leading-tight">{{ pillar.title }}</span>
            </div>
          </template>
          <template #content>
            <p class="text-sm leading-relaxed text-muted-color">{{ pillar.description }}</p>
          </template>
        </p-card>
      </div>
    </section>

    <!-- ── Variant A: Lift Cards ───────────────────────────────────── -->
    <section class="flex flex-col gap-6">
      <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Variant A — Icon Box + Lift</span>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <div
          v-for="pillar in pillars"
          :key="pillar.title"
          class="group flex flex-col gap-5 p-7 rounded-xl border border-surface-700 bg-surface-900 cursor-default
                 transition-all duration-200
                 hover:-translate-y-1.5 hover:border-primary-400 hover:shadow-[0_8px_32px_-4px_color-mix(in_srgb,var(--p-primary-500)_25%,transparent)]"
        >
          <div
            class="flex items-center justify-center w-14 h-14 rounded-xl bg-primary/10
                   transition-colors duration-200 group-hover:bg-primary/20"
          >
            <icon :name="pillar.icon" class="text-4xl text-primary transition-transform duration-200 group-hover:scale-110"/>
          </div>
          <div class="flex flex-col gap-2">
            <h3 class="font-display text-xl font-semibold leading-tight">{{ pillar.title }}</h3>
            <p class="text-sm leading-relaxed text-muted-color">{{ pillar.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- ── Variant B: Horizontal Strip ────────────────────────────── -->
    <section class="flex flex-col gap-6">
      <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Variant B — Horizontal Strip</span>
      <div class="flex flex-col gap-4">
        <div
          v-for="pillar in pillars"
          :key="pillar.title"
          class="group flex items-center gap-7 px-7 py-6 rounded-xl border border-surface-700 bg-surface-900 cursor-default
                 transition-all duration-200
                 hover:border-primary-400 hover:bg-surface-800"
        >
          <div
            class="flex-shrink-0 flex items-center justify-center w-16 h-16 rounded-xl bg-primary/10
                   transition-colors duration-200 group-hover:bg-primary/20"
          >
            <icon :name="pillar.icon" class="text-5xl text-primary transition-transform duration-200 group-hover:scale-110"/>
          </div>
          <div class="flex flex-col gap-1">
            <h3 class="font-display text-xl font-semibold leading-tight">{{ pillar.title }}</h3>
            <p class="text-sm leading-relaxed text-muted-color">{{ pillar.description }}</p>
          </div>
          <icon name="material-symbols:arrow-forward" class="ml-auto flex-shrink-0 text-xl text-muted-color opacity-0 -translate-x-2 transition-all duration-200 group-hover:opacity-100 group-hover:translate-x-0"/>
        </div>
      </div>
    </section>

    <!-- ── Variant C: Glow + Top Accent ───────────────────────────── -->
    <section class="flex flex-col gap-6">
      <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Variant C — Glow + Top Accent</span>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <div
          v-for="pillar in pillars"
          :key="pillar.title"
          class="group relative flex flex-col gap-5 p-7 rounded-xl border border-surface-700 bg-surface-900 cursor-default overflow-hidden
                 transition-all duration-300
                 hover:border-primary-400/50 hover:shadow-[0_0_48px_-8px_color-mix(in_srgb,var(--p-primary-500)_30%,transparent)]"
        >
          <!-- Animated top bar -->
          <div
            class="absolute inset-x-0 top-0 h-0.5 bg-gradient-to-r from-transparent via-primary to-transparent
                   opacity-0 transition-opacity duration-300 group-hover:opacity-100"
          />

          <icon
            :name="pillar.icon"
            class="text-6xl text-primary transition-all duration-300 group-hover:scale-110 group-hover:text-primary-300"
          />

          <div class="flex flex-col gap-2">
            <h3 class="font-display text-xl font-semibold leading-tight">{{ pillar.title }}</h3>
            <p class="text-sm leading-relaxed text-muted-color">{{ pillar.description }}</p>
          </div>
        </div>
      </div>
    </section>

  </div>
</template>
