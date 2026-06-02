<script lang="ts" setup>
definePageMeta({ title: 'Home' })

type RecentArticle = {
  id: string
  title: string
  slug: string
  published_at: string
  article_categories: { name: string; slug: string } | null
}

const supabase = useSupabaseClient()

const { data: recentArticles } = await useAsyncData<RecentArticle[]>(
  'home-recent-articles',
  async () => {
    const { data } = await supabase
      .from('articles')
      .select('id, title, slug, published_at, article_categories(name, slug)')
      .not('published_at', 'is', null)
      .is('archived_at', null)
      .order('published_at', { ascending: false })
      .limit(3)
    return (data as unknown as RecentArticle[]) ?? []
  },
  { lazy: true }
)

const pillars = [
  { icon: 'material-symbols:hub', title: 'Integrations & APIs', description: 'Connecting your platforms, building the APIs that tie them together.' },
  { icon: 'material-symbols:code-blocks', title: 'Application Development', description: 'Custom software and legacy modernization for the way your business actually runs.' },
  { icon: 'material-symbols:smart-toy', title: 'AI & Automation', description: 'Workflow automation and AI-enriched pipelines that eliminate the manual work.' },
  { icon: 'material-symbols:cloud', title: 'Infrastructure & Cloud', description: 'Cloud architecture, networking, and security across AWS, Azure, Cloudflare, and more.' },
]

function formatDate(dateString: string) {
  return new Date(dateString).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })
}
</script>

<template>
  <div>
    <!-- Hero: indigo + amber animated gradient, entrance animation -->
    <section class="hero-gradient flex flex-col items-center justify-center text-center gap-6 px-6 min-h-nav-offset">
      <div class="flex flex-col items-center gap-2">
        <h1 class="text-6xl font-bold text-white fade-up-1">Marek Schir</h1>
        <p class="text-2xl fade-up-2 hero-subtitle">Software Developer & Systems Architect</p>
      </div>
      <p class="text-xl max-w-2xl fade-up-3 hero-headline">
        Building the software and systems that make businesses run better.
      </p>
      <div class="flex gap-4 flex-wrap justify-center fade-up-4">
        <nuxt-link to="/portfolio">
          <p-button label="See My Work" class="hero-outlined-btn" outlined />
        </nuxt-link>
        <nuxt-link to="/contact">
          <p-button label="Get in Touch" class="hero-solid-btn" />
        </nuxt-link>
      </div>
    </section>

    <!-- Shared sections -->
    <div class="max-w-6xl mx-auto px-6 py-16 flex flex-col gap-20">

      <!-- Service Pillars -->
      <div class="flex flex-col gap-6">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">What I Build</span>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
          <p-card v-for="pillar in pillars" :key="pillar.title">
            <template #title>
              <div class="flex flex-col items-start gap-2">
                <icon :name="pillar.icon" class="text-2xl text-primary" />
                <span class="text-sm font-semibold leading-tight">{{ pillar.title }}</span>
              </div>
            </template>
            <template #content>
              <p class="text-sm leading-relaxed text-muted-color">{{ pillar.description }}</p>
            </template>
          </p-card>
        </div>
      </div>

      <!-- Recent Articles -->
      <div class="flex flex-col gap-4">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Recent Articles</span>
        <ul class="article-list">
          <li
            v-for="article in recentArticles"
            :key="article.id"
            class="py-4 flex items-start justify-between gap-4"
          >
            <div class="flex flex-col gap-1">
              <nuxt-link :to="`/articles/${article.slug}`" class="font-medium hover:text-primary transition-colors">
                {{ article.title }}
              </nuxt-link>
              <span v-if="article.article_categories" class="text-sm text-muted-color">
                {{ article.article_categories.name }}
              </span>
            </div>
            <span class="text-sm shrink-0 pt-1 text-muted-color">
              {{ formatDate(article.published_at) }}
            </span>
          </li>
        </ul>
      </div>

      <!-- Bottom CTA -->
      <div class="py-16 flex flex-col items-center gap-5 text-center">
        <p class="text-lg max-w-lg leading-relaxed">
          Got a system, workflow, or idea that needs the right technology behind it? Let's talk.
        </p>
        <nuxt-link to="/contact">
          <p-button label="Get in Touch" />
        </nuxt-link>
      </div>

    </div>

  </div>
</template>

<style scoped>
.hero-gradient {
  background: linear-gradient(135deg, var(--p-primary-950) 0%, var(--p-primary-800) 60%, var(--p-accent-800) 100%);
  background-size: 200% 200%;
  animation: gradientShift 10s ease infinite;
}
@keyframes gradientShift {
  0%   { background-position: 0% 50%; }
  50%  { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.fade-up-1 { animation: fadeUp 0.6s ease both; }
.fade-up-2 { animation: fadeUp 0.6s ease 0.12s both; }
.fade-up-3 { animation: fadeUp 0.6s ease 0.24s both; }
.fade-up-4 { animation: fadeUp 0.6s ease 0.36s both; }
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(18px); }
  to   { opacity: 1; transform: translateY(0); }
}

.hero-outlined-btn {
  color: #fff !important;
  border-color: rgba(255, 255, 255, 0.6) !important;
}
.hero-solid-btn {
  background: #fff !important;
  color: var(--p-primary-700) !important;
  border-color: #fff !important;
}

.hero-subtitle { color: rgba(255, 255, 255, 0.7); }
.hero-headline { color: rgba(255, 255, 255, 0.85); }

.article-list li + li {
  border-top: 1px solid var(--p-surface-border);
}
</style>
