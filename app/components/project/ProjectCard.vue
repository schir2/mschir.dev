<script setup lang="ts">
import type { ProjectCardItem } from '#shared/types/Project'

const props = defineProps<{
  project: ProjectCardItem
}>()

const supabase = useSupabaseClient()

const resolvedImageUrl = computed<string | null>(() => {
  const path = props.project.image_url
  if (!path) return null
  if (path.startsWith('http://') || path.startsWith('https://')) return path
  return supabase.storage.from('images').getPublicUrl(path).data.publicUrl
})

const visibleSkills = computed(() => props.project.project_skills.slice(0, 5))
const hiddenSkillCount = computed(() => Math.max(0, props.project.project_skills.length - 5))

const displayText = computed<string | null>(() =>
  (props.project.featured && props.project.tagline) ? props.project.tagline : props.project.summary
)

const thumbnailGradients = [
  'linear-gradient(135deg, var(--p-primary-950), var(--p-primary-700))',
  'linear-gradient(135deg, var(--p-primary-900), var(--p-primary-600))',
  'linear-gradient(135deg, var(--p-surface-800), var(--p-primary-800))',
  'linear-gradient(135deg, var(--p-primary-800), var(--p-surface-600))',
  'linear-gradient(135deg, var(--p-primary-950), var(--p-surface-700))',
  'linear-gradient(135deg, var(--p-surface-700), var(--p-primary-700))',
]

function hashName(name: string): number {
  let hash = 0
  for (const char of name) {
    hash = (hash * 31 + char.charCodeAt(0)) & 0xffffffff
  }
  return Math.abs(hash)
}

const thumbnailStyle = computed(() => ({
  background: resolvedImageUrl.value
    ? undefined
    : thumbnailGradients[hashName(props.project.name) % thumbnailGradients.length],
}))
</script>

<template>
  <article
    class="group relative flex overflow-hidden rounded-lg border border-surface-800 bg-surface-900 cursor-pointer
           opacity-85 transition-all duration-200
           hover:opacity-100 hover:shadow-xl hover:shadow-black/40 hover:border-surface-700"
  >
    <div
      v-if="project.featured"
      class="w-1.5 shrink-0 bg-amber-500 opacity-80 transition-opacity duration-200 group-hover:opacity-100"
    />

    <div class="flex gap-4 p-4 w-full min-w-0">
      <div class="flex flex-col gap-1.5 flex-1 min-w-0">

        <span class="text-xs text-surface-300">
          {{ project.companies ? `${project.companies.name} · ` : '' }}{{ project.year }}
        </span>

        <span class="font-display text-lg font-semibold leading-snug line-clamp-2 group-hover:text-primary-400 transition-colors duration-200">
          {{ project.name }}
        </span>

        <p v-if="displayText" class="text-sm text-surface-400 line-clamp-3">
          {{ displayText }}
        </p>

        <div class="mt-auto pt-2 border-t border-surface-800 flex flex-wrap items-center gap-2">
          <span
            v-for="skillLink in visibleSkills"
            :key="skillLink.skills.id"
            class="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-300 leading-none"
          >
            <icon v-if="skillLink.skills.icon" :name="skillLink.skills.icon" class="text-sm shrink-0" />
            {{ skillLink.skills.name }}
          </span>
          <span
            v-if="hiddenSkillCount > 0"
            class="text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-500 leading-none"
          >
            +{{ hiddenSkillCount }}
          </span>
        </div>
      </div>

      <div
        class="w-24 h-24 shrink-0 rounded-lg overflow-hidden self-center"
        :style="thumbnailStyle"
      >
        <img
          v-if="resolvedImageUrl"
          :src="resolvedImageUrl"
          :alt="project.name"
          class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
        />
      </div>
    </div>
  </article>
</template>
