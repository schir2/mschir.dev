<!-- PROTOTYPE — layout resolved, copy is draft. Delete switcher and placeholder photo once real headshot is added. -->
<script lang="ts" setup>
definePageMeta({ title: 'About' })

type RecentArticle = {
  id: string
  title: string
  slug: string
  published_at: string
  article_categories: { name: string; slug: string } | null
}

const supabase = useSupabaseClient()

const { data: recentArticles } = await useAsyncData<RecentArticle[]>(
  'about-recent-articles',
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

function formatDate(dateString: string) {
  return new Date(dateString).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })
}
</script>

<template>
  <div class="max-w-4xl mx-auto px-6 py-16 flex flex-col gap-16">

    <!-- Intro: name + photo side by side -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-10 items-start">

      <!-- Name + identity + first paragraph: left two-thirds -->
      <div class="md:col-span-2 flex flex-col gap-4">
        <div>
          <h1 class="text-4xl font-bold">Marek Schir</h1>
          <p class="text-lg mt-1" style="color: var(--p-text-muted-color)">Software Developer & Systems Architect</p>
        </div>
        <p class="leading-relaxed">
          I didn't take the straight path here. I started out wanting to work in 3D graphics and design — building
          with tools like 3ds Max and Photoshop felt creative in a way that was hard to articulate. When that path
          didn't make practical sense, I shifted to software development, then to network infrastructure (I hold CCNA
          and CCNP certifications from that era), and eventually landed at the intersection of all of it. For the past
          14 years I've been the person who sees the whole picture — the network, the application, the integrations,
          and the people who depend on all of it working together.
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
        Most of my work has been with small and medium-sized businesses — field service companies, operations-heavy
        organizations, and teams where technology needs to fit the workflow rather than reshape it. I spend a lot of
        time upfront mapping out how things actually work before writing any code. It's slower at the start, but it
        means what gets built doesn't need to be undone six months later.
      </p>
      <p class="leading-relaxed">
        At the core of it, I like building things. There's something satisfying about starting with a complicated
        problem and ending with something that makes someone's day move faster and easier — whether that's a custom
        application, an automation that eliminates a tedious manual process, or an integration that finally makes two
        systems talk to each other. The goal is always the same: make it work better than it did before.
      </p>
    </div>

    <!-- Recent Articles -->
    <div class="flex flex-col gap-4">
      <span class="text-xs uppercase tracking-widest font-medium" style="color: var(--p-text-muted-color)">Recent Articles</span>
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
            <span v-if="article.article_categories" class="text-sm" style="color: var(--p-text-muted-color)">
              {{ article.article_categories.name }}
            </span>
          </div>
          <span class="text-sm shrink-0 pt-1" style="color: var(--p-text-muted-color)">
            {{ formatDate(article.published_at) }}
          </span>
        </li>
      </ul>
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

<style scoped>
.article-list li + li {
  border-top: 1px solid var(--p-surface-border);
}
</style>
