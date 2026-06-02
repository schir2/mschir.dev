<script lang="ts" setup>
import type {FeaturedProject} from "#shared/types/Project";
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
          .select('*, projects(name, description, image_url, year, project_skills(skills(id, name, icon)))')
          .order('display_order')
      return (data as unknown as FeaturedProject[]) ?? []
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

  </section>
</template>
