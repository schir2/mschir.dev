<script lang="ts" setup>
import type {Skill} from "#shared/types/Skill";

interface Props {
  skills: Pick<Skill, 'id' | 'name' | 'icon'>[]
}

const {skills} = defineProps<Props>()
</script>
<template>
  <div v-if="skills.length > 0" class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-4">
    <div
      v-for="skill in skills"
      :key="skill.id"
      class="flex flex-col items-center gap-2 p-3"
    >
      <icon v-if="skill.icon" :name="skill.icon" class="text-3xl text-primary"/>
      <span class="text-xs text-center text-surface-300 leading-tight">{{ skill.name }}</span>
    </div>
  </div>
</template>
