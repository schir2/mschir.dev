<script lang="ts" setup>
import type {Skill} from "#shared/types/Skill";
import type {FeaturedProject} from "#shared/types/Projects";
import type {ArticleListItem} from "#shared/types/Articles";

definePageMeta({title: 'Portfolio'})

const supabase = useSupabaseClient()

const {data: highlightedSkills} = await useAsyncData<Pick<Skill, 'id' | 'name' | 'icon'>[]>(
    'portfolio-skills',
    async () => {
      const {data} = await supabase
          .from('skills')
          .select('id, name, icon')
          .eq('is_highlighted', true)
          .order('name')
      return data ?? []
    },
    {lazy: true}
)

const {data: featuredProjects} = await useAsyncData<FeaturedProject[]>(
    'portfolio-featured-projects',
    async () => {
      const {data} = await supabase
          .from('featured_projects')
          .select('*, projects(name, description, image_url, year, project_skills(skills(id, name, icon)))')
          .order('display_order')
      return (data as unknown as FeaturedProject[]) ?? []
    },
    {lazy: true}
)

const {data: featuredArticles} = await useAsyncData<ArticleListItem[]>(
    'portfolio-featured-articles',
    async () => {
      const {data} = await supabase
          .from('featured_articles')
          .select('articles(id, title, slug, image_url, created_at, author, article_topics(name, slug))')
      const articles = data?.map(row => row.articles).filter(Boolean) ?? []
      return articles as unknown as ArticleListItem[]
    },
    {lazy: true}
)
</script>
<template>
  <section class="max-w-6xl mx-auto px-6 py-16 flex flex-col gap-16">

    <!-- Skills Snapshot -->
    <div>
      <h2 class="text-2xl font-bold mb-6">Skills</h2>
      <portfolio-skills-snapshot v-if="highlightedSkills?.length" :skills="highlightedSkills"/>
    </div>

    <!-- Featured Projects -->
    <div v-if="featuredProjects?.length">
      <h2 class="text-2xl font-bold mb-6">Featured Projects</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <portfolio-featured-project-card
            v-for="featuredProject in featuredProjects"
            :key="featuredProject.id"
            :featured-project="featuredProject"
        />
      </div>
    </div>

    <!-- Featured Articles -->
    <div v-if="featuredArticles?.length">
      <h2 class="text-2xl font-bold mb-6">Articles</h2>
      <div class="flex flex-col gap-4">
        <router-link
            v-for="article in featuredArticles"
            :key="article.id"
            :to="`/articles/${article.slug}`"
            class="block"
        >
          <p-card>
            <template #title>{{ article.title }}</template>
            <template #content>
              <div class="flex flex-wrap gap-2 mt-1">
                <p-tag
                    v-if="article.article_topics"
                    :value="article.article_topics.name"
                    severity="secondary"
                />
              </div>
            </template>
          </p-card>
        </router-link>
      </div>
    </div>

  </section>
</template>
