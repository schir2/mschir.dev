<script lang="ts" setup>
import { ARTICLE_CARD_SELECT } from '#shared/types/Article'
import type {ArticleCardItem} from '#shared/types/Article'

definePageMeta({})

const heroMounted = ref(false)
onMounted(() => nextTick(() => (heroMounted.value = true)))

usePageSeo({
  title: undefined,
  description: 'Software Developer & Systems Architect building custom integrations, applications, and AI workflows for growing businesses.',
})

useSchemaOrg([
  defineWebSite(),
  definePerson({
    name: 'Marek Schir',
    url: '/about',
    description: 'Software Developer & Systems Architect with 14 years of experience across networking, infrastructure, software development, and integrations.',
  }),
])

const supabase = useSupabaseClient()

const {data: recentArticles} = await useAsyncData<ArticleCardItem[]>(
    'home-recent-articles',
    async () => {
      const {data} = await supabase
          .from('articles')
          .select(ARTICLE_CARD_SELECT)
          .not('published_at', 'is', null)
          .is('archived_at', null)
          .order('published_at', {ascending: false})
          .limit(3)
      return (data as unknown as ArticleCardItem[]) ?? []
    },
    {lazy: true}
)

const pillars = [
  {
    icon: 'material-symbols:hub',
    title: 'Integrations & APIs',
    description: 'Connecting your platforms, building the APIs that tie them together.',
    to: '/services/integrations-apis',
  },
  {
    icon: 'material-symbols:code-blocks',
    title: 'Application Development',
    description: 'Custom software and legacy modernization for the way your business actually runs.',
    to: '/services/application-development',
  },
  {
    icon: 'material-symbols:smart-toy',
    title: 'AI & Automation',
    description: 'Workflow automation and AI-enriched pipelines that eliminate the manual work.',
    to: '/services/ai-automation',
  },
]
</script>

<template>
  <div>
    <!-- Hero: violet + amber animated gradient, entrance animation -->
    <section :class="['hero-gradient flex flex-col items-center justify-center text-center gap-6 px-6 min-h-nav-offset', { 'hero-mounted': heroMounted }]">
      <div class="flex flex-col items-center gap-2">
        <h1 class="text-6xl font-bold text-white hero-item hero-item-1">Marek Schir</h1>
        <p class="text-2xl hero-subtitle hero-item hero-item-2">Software Developer & Systems Architect</p>
      </div>
      <p class="text-xl max-w-2xl hero-headline hero-item hero-item-3">
        Building the software and systems that make businesses run better.
      </p>
      <div class="flex gap-4 flex-wrap justify-center hero-item hero-item-4">
        <nuxt-link to="/portfolio">
          <p-button label="See My Work" class="hero-outlined-btn" outlined/>
        </nuxt-link>
        <nuxt-link to="/contact">
          <p-button label="Get in Touch" class="btn-accent"/>
        </nuxt-link>
      </div>
    </section>

    <!-- Shared sections -->
    <div class="max-w-6xl mx-auto px-6 py-16 flex flex-col gap-20">

      <!-- Service Pillars -->
      <div class="flex flex-col gap-6">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">What I Build</span>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
          <nuxt-link
            v-for="pillar in pillars"
            :key="pillar.title"
            :to="pillar.to"
            class="pillar-card group relative flex items-center gap-6 p-6 rounded-xl border border-surface-200 bg-surface-100 dark:border-surface-700 dark:bg-surface-900 overflow-hidden"
          >
            <div class="pillar-top-bar absolute inset-x-0 top-0 h-0.5"/>
            <div class="flex flex-col gap-2 flex-1">
              <h2 class="text-2xl font-semibold leading-tight">{{ pillar.title }}</h2>
              <p class="text-base leading-relaxed text-muted-color">{{ pillar.description }}</p>
            </div>
            <icon :name="pillar.icon" class="pillar-icon flex-shrink-0 text-6xl"/>
          </nuxt-link>
        </div>
      </div>

      <!-- Recent Articles -->
      <div v-if="recentArticles?.length" class="flex flex-col gap-4">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Recent Articles</span>
        <div class="flex flex-col gap-4">
          <article-card
              v-for="article in recentArticles"
              :key="article.id"
              :article="article"
          />
        </div>
      </div>

      <!-- Bottom CTA -->
      <div class="py-16 flex flex-col items-center gap-6 text-center">
        <p class="text-lg max-w-lg leading-relaxed">
          Got a system, workflow, or idea that needs the right technology behind it? Let's talk.
        </p>
        <nuxt-link to="/contact">
          <p-button label="Get in Touch" class="btn-accent"/>
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
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* Before mount: elements are fully visible (SSR-safe, no animation applied) */
/* After mount: hero-mounted class enables animations via hero-item-* */

.hero-mounted .hero-item {
  opacity: 0;
}

.hero-mounted .hero-item-1 {
  animation: fadeUp 0.6s ease forwards;
}

.hero-mounted .hero-item-2 {
  animation: fadeUp 0.6s ease 0.12s forwards;
}

.hero-mounted .hero-item-3 {
  animation: fadeUp 0.6s ease 0.24s forwards;
}

.hero-mounted .hero-item-4 {
  animation: fadeUp 0.6s ease 0.36s forwards;
}

/* Stop hero animations during page leave so the opacity transition is clean */
.page-leave-active .hero-item {
  animation: none;
}

@keyframes fadeUp {
  from {
    opacity: 0;
    transform: translateY(18px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.hero-outlined-btn {
  color: #fff !important;
  border-color: rgba(255, 255, 255, 0.6) !important;
}


.pillar-icon {
  color: var(--p-accent-400);
  transition: transform 0.3s, filter 0.3s;
}

.pillar-card {
  transition: border-color 0.3s, box-shadow 0.3s;
}

.pillar-card:hover {
  border-color: color-mix(in srgb, var(--p-accent-500) 50%, transparent);
  box-shadow: 0 0 48px -8px color-mix(in srgb, var(--p-accent-500) 30%, transparent);
}

.pillar-card:hover .pillar-icon {
  transform: scale(1.1);
  filter: brightness(1.2);
}

.pillar-top-bar {
  background: linear-gradient(to right, transparent, var(--p-accent-500), transparent);
  opacity: 0;
  transition: opacity 0.3s;
}

.pillar-card:hover .pillar-top-bar {
  opacity: 1;
}

.hero-subtitle {
  color: rgba(255, 255, 255, 0.7);
}

.hero-headline {
  color: rgba(255, 255, 255, 0.85);
}

</style>
