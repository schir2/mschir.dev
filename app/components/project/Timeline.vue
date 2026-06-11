<script setup lang="ts">
import type {ProjectWithSkills} from '#shared/types/Project'

defineProps<{
  projects: ProjectWithSkills[]
}>()
</script>


<template>
  <div class="card">
    <p-timeline :value="projects" align="alternate" class="customized-timeline">
      <template #marker>
        <span class="flex w-8 h-8 items-center justify-center text-white rounded-full z-10 shadow-sm bg-primary">
          <icon name="material-symbols:code"/>
        </span>
      </template>
      <template #content="slotProps">
        <p-card>
          <template #title>{{ slotProps.item.name }}</template>
          <template #subtitle>{{ slotProps.item.year }}</template>
          <template #content>
            <div class="flex flex-col gap-2">
            <img v-if="slotProps.item.image_url" :src="slotProps.item.image_url" :alt="slotProps.item.name" width="200"
                 class="shadow-sm"/>
            <p v-if="slotProps.item.summary">{{ slotProps.item.summary }}</p>
            <div v-if="slotProps.item.project_skills?.length" class="flex flex-wrap gap-1">
              <template v-for="{ skills : skill } in slotProps.item.project_skills"
                        :key="skill.id">
                <p-chip :label="skill.name" >
                  <template #icon>
                    <icon v-if="skill.icon" :name="skill.icon"/>
                  </template>
                </p-chip>
              </template>
            </div>
            </div>
          </template>
        </p-card>
      </template>
    </p-timeline>
  </div>
</template>

<style scoped>
@media screen and (max-width: 960px) {
  :deep(.customized-timeline) .p-timeline-event:nth-child(even) {
    flex-direction: row;
  }

  :deep(.customized-timeline) .p-timeline-event:nth-child(even) .p-timeline-event-content {
    text-align: left;
  }

  :deep(.customized-timeline) .p-timeline-event-opposite {
    flex: 0;
  }
}
</style>
