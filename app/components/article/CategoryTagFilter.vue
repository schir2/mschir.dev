<script lang="ts" setup>
import type { ArticleTag } from '#shared/types/Article'
import type { ArticleCategory } from '#shared/types/ArticleCategory'

const props = defineProps<{
  categories: ArticleCategory[]
  tags: ArticleTag[]
  modelCategory: string | null
  modelTags: string[]
}>()

const emit = defineEmits<{
  'update:modelCategory': [slug: string | null]
  'update:modelTags': [slugs: string[]]
}>()

const activeCount = computed<number>(() =>
  (props.modelCategory ? 1 : 0) + props.modelTags.length,
)

const panelHeader = computed<string>(() =>
  activeCount.value > 0 ? `Filters (${activeCount.value} active)` : 'Filters',
)

const activeCategoryStyle: Record<string, string> = {
  boxShadow: 'inset 0 0 0 2px var(--p-accent-500)',
  color: 'var(--p-accent-400)',
}

const activeTagStyle: Record<string, string> = {
  boxShadow: 'inset 0 0 0 2px var(--p-primary-color)',
  color: 'var(--p-primary-color)',
}

function toggleCategory(slug: string): void {
  emit('update:modelCategory', props.modelCategory === slug ? null : slug)
}

function toggleTag(slug: string): void {
  const updated = props.modelTags.includes(slug)
    ? props.modelTags.filter(selectedSlug => selectedSlug !== slug)
    : [...props.modelTags, slug]
  emit('update:modelTags', updated)
}

function clearFilters(): void {
  emit('update:modelCategory', null)
  emit('update:modelTags', [])
}
</script>

<template>
  <div class="flex flex-col gap-2">
    <p-panel toggleable :collapsed="true" :header="panelHeader">
      <div class="flex flex-col gap-4">
        <div class="flex flex-col gap-2">
          <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Categories</span>
          <div class="flex flex-wrap gap-2">
            <button
              v-for="category in categories"
              :key="category.slug"
              type="button"
              @click="toggleCategory(category.slug)"
            >
              <p-chip
                :label="category.name"
                :style="modelCategory === category.slug ? activeCategoryStyle : undefined"
              />
            </button>
          </div>
        </div>

        <div class="flex flex-col gap-2">
          <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Tags</span>
          <div class="flex flex-wrap gap-2">
            <button
              v-for="tag in tags"
              :key="tag.slug"
              type="button"
              @click="toggleTag(tag.slug)"
            >
              <p-chip
                :label="tag.name"
                :style="modelTags.includes(tag.slug) ? activeTagStyle : undefined"
              />
            </button>
          </div>
        </div>
      </div>
    </p-panel>

    <div v-if="activeCount > 0">
      <p-button text severity="secondary" label="Clear filters" @click="clearFilters">
        <template #icon>
          <icon name="material-symbols:filter-list-off" class="text-lg" />
        </template>
      </p-button>
    </div>
  </div>
</template>
