<script lang="ts" setup>
import type {FeaturedProject} from "#shared/types/Projects";

interface Props {
  featuredProject: FeaturedProject
}

const {featuredProject} = defineProps<Props>()
</script>
<template>
  <p-card class="h-full">
    <template #header>
      <img
        v-if="featuredProject.projects.image_url"
        :src="featuredProject.projects.image_url"
        :alt="featuredProject.projects.name"
        class="w-full h-48 object-cover"
      />
    </template>
    <template #title>{{ featuredProject.projects.name }}</template>
    <template #subtitle>{{ featuredProject.tagline }}</template>
    <template #content>
      <div class="flex flex-wrap gap-2 mt-2">
        <p-tag
          v-for="projectSkill in featuredProject.projects.project_skills"
          :key="projectSkill.skills.id"
          severity="secondary"
        >
          <template #default>
            <div class="flex items-center gap-1">
              <icon v-if="projectSkill.skills.icon" :name="projectSkill.skills.icon" class="text-sm"/>
              <span>{{ projectSkill.skills.name }}</span>
            </div>
          </template>
        </p-tag>
      </div>
    </template>
  </p-card>
</template>
