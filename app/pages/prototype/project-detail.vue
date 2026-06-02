<script setup lang="ts">
definePageMeta({ layout: 'page' })

const fixture = {
  name: 'Environmental Monitoring Platform',
  year: 2023,
  company: 'MMEnviro',
  summary: 'A real-time data platform for environmental sensor networks across remote field sites.',
  skills: [
    { id: '1', name: 'TypeScript', icon: 'logos:typescript-icon' },
    { id: '2', name: 'Nuxt', icon: 'logos:nuxt-icon' },
    { id: '3', name: 'Supabase', icon: 'logos:supabase-icon' },
    { id: '4', name: 'PostgreSQL', icon: 'logos:postgresql' },
    { id: '5', name: 'Python', icon: 'logos:python' },
    { id: '6', name: 'Docker', icon: 'logos:docker-icon' },
  ],
  description: `## Overview

Built a web platform for collecting, visualising, and alerting on data from distributed environmental sensors deployed across remote field sites. The system ingests readings from hundreds of sensors every minute and surfaces them in a real-time dashboard.

## What made it interesting

The field sites had unreliable connectivity, so the ingest pipeline had to be tolerant of out-of-order and duplicate readings. Designed a deduplication layer in PostgreSQL using \`INSERT ... ON CONFLICT DO NOTHING\` combined with a time-bucketed aggregation job.

## Stack decisions

Went with Supabase for the backend — the realtime subscriptions made it straightforward to push sensor updates to the browser without polling. Nuxt handled the frontend with server-side rendering for the public-facing dashboards.`,
}

const gradientBg = 'linear-gradient(135deg, var(--p-primary-950), var(--p-primary-700))'
</script>

<template>
  <div class="flex flex-col gap-16">

    <div class="text-xs text-surface-500 border border-surface-700 rounded px-3 py-2 bg-surface-900">
      Prototype — two layout variants for <code>/projects/[slug]</code>. Fixture data, no real Supabase fetch.
    </div>

    <!-- ─── VARIANT A: Overlay hero ──────────────────────────────────────────── -->
    <section>
      <p class="text-xs font-mono text-amber-400 mb-4 uppercase tracking-widest">Variant A — Overlay hero</p>

      <article class="flex flex-col gap-8">

        <!-- Hero block: gradient bg simulating an image, title overlaid -->
        <div
          class="relative w-full rounded-xl overflow-hidden"
          style="min-height: 18rem;"
          :style="{ background: gradientBg }"
        >
          <!-- scrim -->
          <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent" />

          <!-- content pinned to bottom of hero -->
          <div class="absolute bottom-0 left-0 right-0 p-8">
            <div class="flex justify-between items-end gap-4">
              <div>
                <div class="flex items-center gap-2 mb-3">
                  <span class="text-sm font-medium text-surface-300">{{ fixture.company }}</span>
                  <span class="text-surface-600">·</span>
                  <span class="text-sm text-surface-400">{{ fixture.year }}</span>
                </div>
                <h1 class="text-4xl font-display font-bold text-white leading-tight">
                  {{ fixture.name }}
                </h1>
              </div>
              <!-- placeholder for edit button -->
              <div class="shrink-0">
                <p-button label="Edit" icon="pi pi-pencil" size="small" severity="secondary" />
              </div>
            </div>
          </div>
        </div>

        <!-- Skills -->
        <div class="flex flex-wrap gap-2">
          <span
            v-for="skill in fixture.skills"
            :key="skill.id"
            class="flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-full bg-surface-800 text-surface-300 leading-none"
          >
            <icon v-if="skill.icon" :name="skill.icon" class="text-sm shrink-0" />
            {{ skill.name }}
          </span>
        </div>

        <!-- Body placeholder -->
        <div class="max-w-3xl flex flex-col gap-4 text-surface-300 text-sm leading-relaxed">
          <p class="text-base text-surface-200 font-medium">{{ fixture.summary }}</p>
          <p class="text-surface-400">[ markdown body renders here ]</p>
        </div>

      </article>
    </section>

    <hr class="border-surface-800" />

    <!-- ─── VARIANT B: Stacked — big title + metadata accent bar ─────────────── -->
    <section>
      <p class="text-xs font-mono text-amber-400 mb-4 uppercase tracking-widest">Variant B — Stacked, big title + metadata accent</p>

      <article class="flex flex-col gap-8">

        <!-- Hero image (gradient fallback) -->
        <div
          class="w-full rounded-xl overflow-hidden"
          style="height: 14rem;"
          :style="{ background: gradientBg }"
        />

        <!-- Header block -->
        <header class="flex flex-col gap-4">
          <div class="flex justify-between items-start gap-4">
            <h1 class="text-5xl font-display font-bold leading-tight">
              {{ fixture.name }}
            </h1>
            <div class="shrink-0 pt-2">
              <p-button label="Edit" icon="pi pi-pencil" size="small" severity="secondary" />
            </div>
          </div>

          <!-- Metadata accent bar -->
          <div class="flex items-center gap-0 self-start">
            <div class="h-8 w-1 rounded-full bg-primary-500 mr-4" />
            <span class="text-base font-semibold text-surface-100">{{ fixture.company }}</span>
            <span class="mx-3 text-surface-600">·</span>
            <span class="text-base text-surface-400">{{ fixture.year }}</span>
          </div>

          <!-- Skills -->
          <div class="flex flex-wrap gap-2">
            <span
              v-for="skill in fixture.skills"
              :key="skill.id"
              class="flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-full bg-surface-800 text-surface-300 leading-none"
            >
              <icon v-if="skill.icon" :name="skill.icon" class="text-sm shrink-0" />
              {{ skill.name }}
            </span>
          </div>
        </header>

        <!-- Body placeholder -->
        <div class="max-w-3xl flex flex-col gap-4 text-surface-300 text-sm leading-relaxed">
          <p class="text-base text-surface-200 font-medium">{{ fixture.summary }}</p>
          <p class="text-surface-400">[ markdown body renders here ]</p>
        </div>

      </article>
    </section>

  </div>
</template>
