<script lang="ts" setup>
// PROTOTYPE — throwaway. Question: do the skeleton shapes feel right?
// Delete or absorb into real pages once approved.
import type { ArticleCardItem, ArticleSeriesSummary } from '#shared/types/Article'
import type { ProjectCardItem } from '#shared/types/Project'

definePageMeta({ title: 'Prototype: Skeletons', layout: 'page', pageTransition: false, layoutTransition: false })

const route = useRoute()
const router = useRouter()

type Variant = 'loading' | 'loaded' | 'compare'
const variant = computed<Variant>(() => (route.query.v as Variant) || 'compare')

function setVariant(v: Variant) {
  router.replace({ query: { v } })
}

const showLoading = computed(() => variant.value === 'loading' || variant.value === 'compare')
const showLoaded = computed(() => variant.value === 'loaded' || variant.value === 'compare')

const fixtureArticle: ArticleCardItem = {
  id: 'fixture-1',
  title: 'Getting Started with Supabase Row Level Security',
  slug: 'getting-started-with-supabase-rls',
  summary: 'A practical guide to writing RLS policies that are readable, testable, and actually do what you think they do.',
  published_at: '2026-01-15T00:00:00Z',
  image_url: null,
  series_id: null,
  series_sequence_number: null,
  article_categories: { name: 'Software Development', slug: 'software-development', color: '#6366f1', image_url: null },
  article_tags_links: [
    { article_tags: { name: 'Supabase', slug: 'supabase', icon: 'logos:supabase-icon' } },
    { article_tags: { name: 'PostgreSQL', slug: 'postgresql', icon: 'logos:postgresql' } },
    { article_tags: { name: 'Security', slug: 'security', icon: null } },
  ],
  article_series: null,
  featured_articles: null,
}

const fixtureFeaturedArticle: ArticleCardItem = {
  ...fixtureArticle,
  id: 'fixture-2',
  title: 'Building a Multi-Tenant SaaS App with Nuxt and Supabase',
  slug: 'multi-tenant-saas-nuxt-supabase',
  featured_articles: { id: 'feat-1', featured_reason: 'Staff pick' },
}

const fixtureProject: ProjectCardItem = {
  id: 'fixture-p1',
  name: 'Field Service Management Platform',
  year: 2024,
  summary: 'A full-stack job scheduling and dispatch application for a regional field service company. Handles work orders, technician routing, and customer notifications.',
  slug: 'field-service-management',
  image_url: null,
  companies: { name: 'Acme Services' },
  project_skills: [
    { skills: { id: 's1', name: 'Vue.js', icon: 'logos:vue' } },
    { skills: { id: 's2', name: 'Nuxt', icon: 'logos:nuxt-icon' } },
    { skills: { id: 's3', name: 'Supabase', icon: 'logos:supabase-icon' } },
    { skills: { id: 's4', name: 'Python', icon: 'logos:python' } },
  ],
  tagline: null,
  featured: false,
}

const fixtureSeries: ArticleSeriesSummary = {
  id: 'fixture-s1',
  title: 'Building with Supabase',
  slug: 'building-with-supabase',
  description: 'A step-by-step series covering Supabase auth, row level security, edge functions, and realtime subscriptions.',
  image_url: null,
  article_count: 5,
}

const categoryPills = ['Software Development', 'Career', 'Finance', 'Infrastructure', 'AI & Automation', 'Architecture']
const tagPills = ['Supabase', 'PostgreSQL', 'Vue.js', 'Nuxt', 'Python', 'TypeScript', 'Docker', 'AWS']
</script>

<template>
  <div class="flex flex-col gap-16 pb-32">
    <div class="flex flex-col gap-2">
      <h1 class="text-4xl font-bold">Skeleton Loading States</h1>
      <p class="text-surface-400 text-sm">Prototype — use the bottom bar to switch views. Delete once shapes are approved.</p>
    </div>

    <!-- Article Cards -->
    <section class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Article Cards</h2>
      <div :class="variant === 'compare' ? 'grid grid-cols-2 gap-8' : ''">
        <div v-if="showLoading" class="flex flex-col gap-4">
          <p class="text-xs uppercase tracking-widest text-surface-500 font-medium">Loading (3 cards)</p>
          <article-card loading />
          <article-card loading />
          <article-card loading />
        </div>
        <div v-if="showLoaded" class="flex flex-col gap-4">
          <p class="text-xs uppercase tracking-widest text-surface-500 font-medium">Loaded</p>
          <article-card :article="fixtureFeaturedArticle" />
          <article-card :article="fixtureArticle" />
        </div>
      </div>
    </section>

    <!-- Project Cards -->
    <section class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Project Cards</h2>
      <div :class="variant === 'compare' ? 'grid grid-cols-2 gap-8' : ''">
        <div v-if="showLoading" class="flex flex-col gap-4">
          <p class="text-xs uppercase tracking-widest text-surface-500 font-medium">Loading (3 cards)</p>
          <project-card loading />
          <project-card loading />
          <project-card loading />
        </div>
        <div v-if="showLoaded" class="flex flex-col gap-4">
          <p class="text-xs uppercase tracking-widest text-surface-500 font-medium">Loaded</p>
          <project-card :project="fixtureProject" />
        </div>
      </div>
    </section>

    <!-- Series Cards -->
    <section class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Series Cards</h2>
      <div :class="variant === 'compare' ? 'grid grid-cols-2 gap-8' : ''">
        <div v-if="showLoading" class="flex flex-col gap-4">
          <p class="text-xs uppercase tracking-widest text-surface-500 font-medium">Loading (2-col grid)</p>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <article-series-card loading />
            <article-series-card loading />
          </div>
        </div>
        <div v-if="showLoaded" class="flex flex-col gap-4">
          <p class="text-xs uppercase tracking-widest text-surface-500 font-medium">Loaded</p>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <article-series-card :series="fixtureSeries" />
          </div>
        </div>
      </div>
    </section>

    <!-- Browse Filter Bar -->
    <section class="flex flex-col gap-6">
      <h2 class="text-2xl font-bold">Browse Filter Bar</h2>
      <div :class="variant === 'compare' ? 'grid grid-cols-2 gap-8' : ''">
        <div v-if="showLoading" class="flex flex-col gap-4">
          <p class="text-xs uppercase tracking-widest text-surface-500 font-medium">Loading</p>
          <div class="flex flex-col gap-4">
            <div class="flex flex-wrap gap-2">
              <div v-for="n in 6" :key="n" class="h-[28px] rounded-full bg-surface-700 animate-pulse" :style="`width: ${60 + n * 12}px`" />
            </div>
            <div class="flex flex-wrap gap-2">
              <div v-for="n in 8" :key="n" class="h-[28px] rounded-full bg-surface-700 animate-pulse" :style="`width: ${50 + n * 10}px`" />
            </div>
          </div>
        </div>
        <div v-if="showLoaded" class="flex flex-col gap-4">
          <p class="text-xs uppercase tracking-widest text-surface-500 font-medium">Loaded</p>
          <div class="flex flex-col gap-4">
            <div class="flex flex-wrap gap-2">
              <span
                v-for="pill in categoryPills"
                :key="pill"
                class="inline-flex items-center px-3 py-1 rounded-full border border-surface-600 text-sm"
              >{{ pill }}</span>
            </div>
            <div class="flex flex-wrap gap-2">
              <span
                v-for="pill in tagPills"
                :key="pill"
                class="inline-flex items-center px-3 py-1 rounded-full border border-surface-600 text-sm"
              >{{ pill }}</span>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>

  <!-- Floating variant switcher -->
  <div class="fixed bottom-8 left-1/2 -translate-x-1/2 flex gap-1 bg-surface-800 border border-surface-700 rounded-full px-2 py-2 shadow-xl shadow-black/40 z-50">
    <button
      v-for="(label, key) in { loading: 'Loading', compare: 'Compare', loaded: 'Loaded' }"
      :key="key"
      class="px-4 py-1.5 rounded-full text-sm font-medium transition-colors"
      :class="variant === key ? 'bg-primary text-white' : 'text-surface-400 hover:text-surface-200'"
      @click="setVariant(key as Variant)"
    >
      {{ label }}
    </button>
  </div>
</template>
