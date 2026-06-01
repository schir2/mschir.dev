<script lang="ts" setup>
import type {FeaturedProject} from "#shared/types/Project";
import type {ArticleCardItem} from "#shared/types/Article";
import type {SkillSnapshot} from "~/types/Skill";

definePageMeta({ title: 'Portfolio', layout: 'page' })

const supabase = useSupabaseClient()

const {data: highlightedSkills} = await useAsyncData<SkillSnapshot[]>(
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

const articleCardSelect = 'id, title, slug, summary, published_at, image_url, series_id, series_sequence_number, article_categories(name, slug, color, image_url), article_tags_links(article_tags(name, slug)), article_series(title, slug, image_url)'

const {data: featuredArticles} = await useAsyncData<ArticleCardItem[]>(
    'portfolio-featured-articles',
    async () => {
      const {data} = await supabase
          .from('featured_articles')
          .select(`articles(${articleCardSelect})`)
      const articles = data?.map((row: any) => row.articles).filter(Boolean) ?? []
      return articles as unknown as ArticleCardItem[]
    },
    {lazy: true}
)
</script>
<template>
  <section class="flex flex-col gap-16">

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
                    v-if="article.article_categories"
                    :value="article.article_categories.name"
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
