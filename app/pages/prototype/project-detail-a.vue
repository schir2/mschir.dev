<script setup lang="ts">
definePageMeta({ layout: 'page' })

const fixture = {
  name: 'Environmental Monitoring Platform',
  year: 2023,
  company: 'MMPC',
  logoUrl: 'https://mandmpestcontrol.com/wp-content/uploads/2024/06/MMPC-logo-square.png',
  imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1200&h=480&fit=crop&q=80',
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

The initial version took about three months to get to production. Most of that time wasn't the dashboard — it was wrestling with the ingest pipeline. Field sites had unreliable connectivity, so readings arrived late, out of order, or in duplicate batches. Getting that to behave predictably under real conditions was the bulk of the work.

## Technical decisions

Went with Supabase for the backend. The realtime subscriptions made it straightforward to push sensor updates to the browser without polling, and having Postgres underneath meant I could write the deduplication logic as a proper \`INSERT ... ON CONFLICT DO NOTHING\` with a time-bucketed aggregation job rather than handling it in application code.

Nuxt handled the frontend. The public-facing dashboards needed server-side rendering for SEO and initial load performance — client-only rendering made the first paint too slow on the slower connections some stakeholders were using.

## What I'd do differently

The alerting system was bolted on late in the project and it shows. Thresholds are hardcoded per-sensor-type rather than configurable per-site. It works, but every time a new site has different acceptable ranges it requires a code change. Worth rebuilding as a rules engine if this goes further.`,
}

const mdTheme = useMdEditorTheme()

const breadcrumbs = [
  { label: 'Projects', route: '/projects' },
  { label: fixture.name },
]
</script>

<template>
  <div>
    <p class="text-xs font-mono text-amber-400 mb-4 uppercase tracking-widest">
      Responsive — overlay on mobile, stacked on desktop
    </p>

    <article class="flex flex-col gap-6">

      <breadcrumb :breadcrumbs="breadcrumbs" />

      <!-- Hero block
           Mobile: tall, title overlaid at bottom with scrim
           Desktop (md+): shorter image only, no overlay, title lives below -->
      <div class="relative w-full rounded-xl overflow-hidden" style="min-height: 16rem;">
        <img
          :src="fixture.imageUrl"
          :alt="fixture.name"
          class="absolute inset-0 w-full h-full object-cover md:relative md:inset-auto md:h-56 md:w-full"
        />

        <!-- Scrim + title: mobile only -->
        <div class="md:hidden absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />
        <div class="md:hidden absolute bottom-0 left-0 right-0 p-6">
          <h1 class="text-2xl font-semibold text-white leading-snug">{{ fixture.name }}</h1>
        </div>
      </div>

      <!-- Title: desktop only -->
      <header class="flex flex-col gap-4">
        <div class="hidden md:flex justify-between items-start gap-4">
          <h1 class="text-3xl font-bold">{{ fixture.name }}</h1>
          <div class="shrink-0 pt-1">
            <p-button label="Edit" icon="pi pi-pencil" size="small" severity="secondary" />
          </div>
        </div>

        <!-- Edit button: mobile (separate row since title is in the hero) -->
        <div class="md:hidden flex justify-end">
          <p-button label="Edit" icon="pi pi-pencil" size="small" severity="secondary" />
        </div>

        <!-- Company + year: same on both breakpoints -->
        <div class="flex items-center gap-2">
          <div style="width:20px;height:20px;flex-shrink:0;overflow:hidden;border-radius:3px;background:white;">
            <img
              :src="fixture.logoUrl"
              :alt="fixture.company"
              style="width:20px;height:20px;object-fit:contain;"
            />
          </div>
          <span class="text-sm font-semibold text-surface-200">{{ fixture.company }}</span>
          <span class="text-surface-600 text-sm">·</span>
          <span class="text-sm text-surface-400">{{ fixture.year }}</span>
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

      <!-- Body: full width to match image -->
      <div class="md-content-preview">
        <client-only>
          <md-preview
            editor-id="prototype-responsive-detail"
            language="en-US"
            :theme="mdTheme"
            :model-value="fixture.description"
          />
        </client-only>
      </div>

    </article>
  </div>
</template>
