<script setup lang="ts">
import type { ProjectCardItem } from '#shared/types/Project'

const props = defineProps<{
  project?: ProjectCardItem
  loading?: boolean
}>()

const { resolveImageUrl } = useStorageUrl()

const resolvedImageUrl = computed<string | null>(() => resolveImageUrl(props.project?.image_url ?? null))

const visibleSkills = computed(() => props.project?.project_skills.slice(0, 5) ?? [])
const hiddenSkillCount = computed(() => Math.max(0, (props.project?.project_skills.length ?? 0) - 5))

const displayText = computed<string | null>(() =>
  props.project ? ((props.project.featured && props.project.tagline) ? props.project.tagline : props.project.summary) : null
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
    : props.project
      ? thumbnailGradients[hashName(props.project.name) % thumbnailGradients.length]
      : thumbnailGradients[0],
}))
</script>

<template>
  <article
    class="group relative flex overflow-hidden rounded-lg border border-surface-200 bg-surface-100 dark:border-surface-800 dark:bg-surface-900"
    :class="loading ? 'cursor-default' : 'cursor-pointer opacity-85 transition-all duration-200 hover:opacity-100 hover:shadow-xl hover:shadow-black/10 dark:hover:shadow-black/40 hover:border-surface-300 dark:hover:border-surface-700'"
  >
    <template v-if="loading">
      <div class="w-1.5 shrink-0 bg-surface-200 dark:bg-surface-700 animate-pulse" />
      <div class="flex flex-col w-full min-w-0">
        <div class="flex gap-2 sm:gap-4 px-4 pt-4 pb-2 min-w-0">
          <div class="flex flex-col gap-2 flex-1 min-w-0">
            <div class="h-[10px] w-[30%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse" />
            <div class="h-[18px] w-[75%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse" />
            <div class="h-[18px] w-[48%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse" />
            <div class="h-[13px] w-[60%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse" />
          </div>
          <div class="w-16 h-16 sm:w-24 sm:h-24 rounded-lg bg-surface-200 dark:bg-surface-700 animate-pulse shrink-0 self-center" />
        </div>
        <div class="px-4 pb-4 pt-2 border-t border-surface-200 dark:border-surface-800 flex gap-2">
          <div class="h-[22px] w-[65px] rounded-full bg-surface-200 dark:bg-surface-700 animate-pulse" />
          <div class="h-[22px] w-[75px] rounded-full bg-surface-200 dark:bg-surface-700 animate-pulse" />
          <div class="h-[22px] w-[60px] rounded-full bg-surface-200 dark:bg-surface-700 animate-pulse" />
        </div>
      </div>
    </template>

    <template v-else-if="project">
      <div
        v-if="project.featured"
        class="w-1.5 shrink-0 bg-amber-500 opacity-80 transition-opacity duration-200 group-hover:opacity-100"
      />

      <div class="flex flex-col w-full min-w-0">
        <div class="flex gap-2 sm:gap-4 px-4 pt-4 pb-2 min-w-0">
          <div class="flex flex-col gap-1.5 flex-1 min-w-0">

            <span class="text-xs text-surface-700 dark:text-surface-300">
              {{ project.companies ? `${project.companies.name} · ` : '' }}{{ project.year }}
            </span>

            <span class="font-display text-lg font-semibold leading-snug line-clamp-2 group-hover:text-primary-400 transition-colors duration-200">
              {{ project.name }}
            </span>

            <p v-if="displayText" class="text-sm text-surface-600 dark:text-surface-400 line-clamp-3">
              {{ displayText }}
            </p>

          </div>

          <div
            class="w-16 h-16 sm:w-24 sm:h-24 shrink-0 rounded-lg overflow-hidden self-start"
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

        <div class="px-4 pb-4 min-w-0">
          <div class="flex flex-wrap items-center gap-2 pt-2 border-t border-surface-200 dark:border-surface-800">
            <span
              v-for="skillLink in visibleSkills"
              :key="skillLink.skills.id"
              class="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-surface-100 text-surface-700 dark:bg-surface-800 dark:text-surface-300 leading-none"
            >
              <icon v-if="skillLink.skills.icon" :name="skillLink.skills.icon" class="w-4 h-4 shrink-0" />
              {{ skillLink.skills.name }}
            </span>
            <span
              v-if="hiddenSkillCount > 0"
              class="text-xs px-2.5 py-1 rounded-full bg-surface-100 text-surface-600 dark:bg-surface-800 dark:text-surface-500 leading-none"
            >
              +{{ hiddenSkillCount }}
            </span>
          </div>
        </div>
      </div>
    </template>
  </article>
</template>
