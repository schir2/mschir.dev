<script lang="ts" setup>
import type {FeaturedProject, ProjectCardItem} from "#shared/types/Project";
import type {SkillSnapshot} from "~/types/Skill";

definePageMeta({title: 'Portfolio', layout: 'page'})

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
          .select('*, projects(id, name, slug, summary, description, image_url, year, companies(name), project_skills(skills(id, name, icon)))')
          .order('display_order')
      return (data as unknown as FeaturedProject[]) ?? []
    },
    {lazy: true}
)

const featuredProjectCards = computed<ProjectCardItem[]>(() =>
  (featuredProjects.value ?? []).map(fp => ({
    id: fp.projects.id,
    name: fp.projects.name,
    year: fp.projects.year,
    summary: fp.projects.summary,
    slug: fp.projects.slug,
    image_url: fp.projects.image_url,
    companies: fp.projects.companies,
    project_skills: fp.projects.project_skills,
    tagline: fp.tagline,
    featured: true,
  }))
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
    <div v-if="featuredProjectCards.length">
      <h2 class="text-2xl font-bold mb-6">Featured Projects</h2>
      <div class="flex flex-col gap-3">
        <project-card
            v-for="project in featuredProjectCards"
            :key="project.id"
            :project="project"
        />
      </div>
    </div>

  </section>
</template>
