<script lang="ts" setup>
import type { ArticleCardItem } from '#shared/types/Article'

definePageMeta({ title: 'Prototype: Browse Filter', layout: 'page' })

const categories = [
  { id: '1', name: 'Software Development', slug: 'software-development' },
  { id: '2', name: 'Infrastructure', slug: 'infrastructure' },
  { id: '3', name: 'Finance', slug: 'finance' },
]

const tags = [
  { id: '1', name: 'Python', slug: 'python' },
  { id: '2', name: 'Supabase', slug: 'supabase' },
  { id: '3', name: 'Vue.js', slug: 'vue.js' },
  { id: '4', name: 'Docker', slug: 'docker' },
  { id: '5', name: 'CI/CD', slug: 'ci-cd' },
  { id: '6', name: 'PostgreSQL', slug: 'postgresql' },
  { id: '7', name: 'TypeScript', slug: 'typescript' },
  { id: '8', name: 'Financial Planning', slug: 'financial-planning' },
]

const allArticles = [
  {
    id: '1', title: 'Getting Started with Supabase', slug: 'getting-started-with-supabase',
    summary: 'A comprehensive guide to setting up your first Supabase project with auth and storage.',
    published_at: '2026-01-15', image_url: null, series_id: null, series_sequence_number: null,
    article_categories: { name: 'Software Development', slug: 'software-development', color: '#818cf8', image_url: null },
    article_tags_links: [
      { article_tags: { name: 'Supabase', slug: 'supabase', icon: 'logos:supabase-icon' } },
      { article_tags: { name: 'PostgreSQL', slug: 'postgresql', icon: 'logos:postgresql' } },
    ],
    article_series: null, featured_articles: null,
  },
  {
    id: '2', title: 'Building with Vue.js and TypeScript', slug: 'vue-typescript-guide',
    summary: 'Best practices for combining Vue.js and TypeScript in production applications.',
    published_at: '2026-02-10', image_url: null, series_id: null, series_sequence_number: null,
    article_categories: { name: 'Software Development', slug: 'software-development', color: '#818cf8', image_url: null },
    article_tags_links: [
      { article_tags: { name: 'Vue.js', slug: 'vue.js', icon: 'logos:vue' } },
      { article_tags: { name: 'TypeScript', slug: 'typescript', icon: 'logos:typescript-icon' } },
    ],
    article_series: null, featured_articles: null,
  },
  {
    id: '3', title: 'Docker and CI/CD for Developers', slug: 'docker-cicd-guide',
    summary: 'Setting up an efficient Docker-based CI/CD pipeline for modern web applications.',
    published_at: '2026-03-05', image_url: null, series_id: null, series_sequence_number: null,
    article_categories: { name: 'Infrastructure', slug: 'infrastructure', color: '#34d399', image_url: null },
    article_tags_links: [
      { article_tags: { name: 'Docker', slug: 'docker', icon: 'logos:docker-icon' } },
      { article_tags: { name: 'CI/CD', slug: 'ci-cd', icon: 'logos:github-actions' } },
    ],
    article_series: null, featured_articles: null,
  },
  {
    id: '4', title: 'Python for Financial Planning', slug: 'python-financial-planning',
    summary: 'Using Python and NumPy to build personal financial planning and retirement tools.',
    published_at: '2026-03-20', image_url: null, series_id: null, series_sequence_number: null,
    article_categories: { name: 'Finance', slug: 'finance', color: '#fbbf24', image_url: null },
    article_tags_links: [
      { article_tags: { name: 'Python', slug: 'python', icon: 'logos:python' } },
      { article_tags: { name: 'Financial Planning', slug: 'financial-planning', icon: null } },
    ],
    article_series: null, featured_articles: null,
  },
  {
    id: '5', title: 'Supabase RLS in Production', slug: 'supabase-rls-production',
    summary: 'Row level security patterns that actually work at scale with real-world examples.',
    published_at: '2026-04-12', image_url: null, series_id: null, series_sequence_number: null,
    article_categories: { name: 'Software Development', slug: 'software-development', color: '#818cf8', image_url: null },
    article_tags_links: [
      { article_tags: { name: 'Supabase', slug: 'supabase', icon: 'logos:supabase-icon' } },
      { article_tags: { name: 'PostgreSQL', slug: 'postgresql', icon: 'logos:postgresql' } },
      { article_tags: { name: 'TypeScript', slug: 'typescript', icon: 'logos:typescript-icon' } },
    ],
    article_series: null, featured_articles: null,
  },
] as unknown as ArticleCardItem[]

const activeCategory = ref<string | null>(null)
const activeTags = ref<string[]>([])

function toggleCategory(slug: string): void {
  activeCategory.value = activeCategory.value === slug ? null : slug
}

function toggleTag(slug: string): void {
  activeTags.value = activeTags.value.includes(slug)
    ? activeTags.value.filter(s => s !== slug)
    : [...activeTags.value, slug]
}

function clearFilters(): void {
  activeCategory.value = null
  activeTags.value = []
}

const hasActiveFilters = computed<boolean>(() => activeCategory.value !== null || activeTags.value.length > 0)

const filteredArticles = computed<ArticleCardItem[]>(() =>
  allArticles.filter(article => {
    const categoryMatch = !activeCategory.value || article.article_categories?.slug === activeCategory.value
    const tagMatch = activeTags.value.length === 0 || activeTags.value.every(tagSlug =>
      article.article_tags_links.some(link => link.article_tags.slug === tagSlug),
    )
    return categoryMatch && tagMatch
  }),
)

const activeCategoryStyle: Record<string, string> = { boxShadow: 'inset 0 0 0 2px var(--p-accent-500)', color: 'var(--p-accent-400)' }
const activeTagStyle: Record<string, string> = { boxShadow: 'inset 0 0 0 2px var(--p-primary-color)', color: 'var(--p-primary-color)' }
</script>

<template>
  <div class="flex flex-col gap-8">
    <div class="flex flex-col gap-2">
      <h1 class="text-4xl font-bold">Browse Filter</h1>
      <p class="text-muted-color">Categories use outlined amber when active. Tags use outlined violet.</p>
    </div>

    <!-- Filter chips -->
    <div class="flex flex-col gap-4">
      <div class="flex flex-col gap-2">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Categories</span>
        <div class="flex flex-wrap gap-2">
          <button
            v-for="category in categories"
            :key="category.slug"
            type="button"
            @click="toggleCategory(category.slug)"
          >
            <p-chip
              :label="category.name"
              :style="activeCategory === category.slug ? activeCategoryStyle : undefined"
            />
          </button>
        </div>
      </div>

      <div class="flex flex-col gap-2">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Tags</span>
        <div class="flex flex-wrap gap-2">
          <button
            v-for="tag in tags"
            :key="tag.slug"
            type="button"
            @click="toggleTag(tag.slug)"
          >
            <p-chip
              :label="tag.name"
              :style="activeTags.includes(tag.slug) ? activeTagStyle : undefined"
            />
          </button>
        </div>
      </div>

      <div v-if="hasActiveFilters">
        <p-button text severity="secondary" label="Clear filters" @click="clearFilters">
          <template #icon>
            <icon name="material-symbols:filter-list-off" class="text-lg" />
          </template>
        </p-button>
      </div>
    </div>

    <!-- Article list -->
    <div class="flex flex-col gap-4">
      <article-card
        v-for="article in filteredArticles"
        :key="article.id"
        :article="article"
      />
      <p v-if="filteredArticles.length === 0" class="text-muted-color">No articles match the selected filters.</p>
    </div>
  </div>
</template>
