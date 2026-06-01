<script lang="ts" setup>
import type { ArticleCardItem } from '#shared/types/Article'

definePageMeta({ title: 'About', layout: 'page' })

const supabase = useSupabaseClient()

const { data: recentArticles } = await useAsyncData<ArticleCardItem[]>(
  'about-recent-articles',
  async () => {
    const { data } = await supabase
      .from('articles')
      .select('id, title, slug, summary, published_at, image_url, series_id, series_sequence_number, article_categories(name, slug, color, image_url), article_tags_links(article_tags(name, slug)), article_series(title, slug, image_url), featured_articles(id, featured_reason)')
      .not('published_at', 'is', null)
      .is('archived_at', null)
      .order('published_at', { ascending: false })
      .limit(3)
    return (data as unknown as ArticleCardItem[]) ?? []
  },
  { lazy: true }
)
</script>

<template>
  <div class="max-w-4xl mx-auto py-16 flex flex-col gap-16">

    <!-- Intro: name + photo side by side -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-10 items-start">

      <!-- Name + identity + first paragraph: left two-thirds -->
      <div class="md:col-span-2 flex flex-col gap-4">
        <div>
          <h1 class="text-4xl font-bold">Marek Schir</h1>
          <p class="text-lg mt-1" style="color: var(--p-text-muted-color)">Software Developer & Systems Architect</p>
        </div>
        <p class="leading-relaxed">
          I didn't take the straight path here. I started out in 3D graphics and design, moved into networking
          (CCNA, CCNP), got hired as a software developer to integrate and automate systems, and eventually took on
          an IT director role on top of that. Fourteen years later I'm still the person who sees the whole picture:
          the network, the application, the integrations, and the people who depend on all of it working together.
        </p>
      </div>

      <!-- Photo: right third -->
      <div class="md:col-span-1 flex justify-center md:justify-end">
        <img src="/img/profile.jpg" alt="Marek Schir" class="w-48 h-48 rounded-full object-cover" />
      </div>

    </div>

    <!-- Continued narrative: full width below the intro block -->
    <div class="flex flex-col gap-5 max-w-2xl">
      <p class="leading-relaxed">
        Most of my work has been with small and medium-sized businesses: field service companies, operations-heavy
        organizations, and teams where technology needs to fit the workflow rather than reshape it. I spend a lot of
        time upfront mapping out how things actually work before writing any code. It's slower at the start, but it
        means what gets built doesn't need to be undone six months later.
      </p>
      <p class="leading-relaxed">
        At the core of it, I like building things. There's something satisfying about starting with a complicated
        problem and ending with something that makes someone's work faster, easier, and more efficient. If I can
        remove a tedious manual process, connect two systems that should have been talking to each other, or set up
        an AI workflow that handles the repetitive parts of someone's day, that's a good outcome. The goal is always
        the same: make it work better than it did before.
      </p>
    </div>

    <!-- Recent Articles -->
    <div class="flex flex-col gap-4">
      <span class="text-xs uppercase tracking-widest font-medium" style="color: var(--p-text-muted-color)">Recent Articles</span>
      <div class="flex flex-col gap-3">
        <article-card
          v-for="article in recentArticles"
          :key="article.id"
          :article="article"
        />
      </div>
    </div>

    <!-- CTA -->
    <div class="py-16 flex flex-col items-center gap-5 text-center">
      <p class="text-lg max-w-md leading-relaxed">
        Want to work together, or just talk through a problem? I'm happy to have a conversation.
      </p>
      <nuxt-link to="/contact">
        <p-button label="Get in Touch" outlined />
      </nuxt-link>
    </div>

  </div>
</template>
