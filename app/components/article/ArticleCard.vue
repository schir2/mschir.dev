<script lang="ts" setup>
import type {ArticleCardItem} from '#shared/types/Article'
import {useArticleThumbnail} from '~/composables/useArticleThumbnail'

const props = defineProps<{
  article?: ArticleCardItem
  loading?: boolean
}>()

const visibleTags = computed(() => props.article?.article_tags_links.slice(0, 3) ?? [])
const hiddenTagCount = computed(() => Math.max(0, (props.article?.article_tags_links.length ?? 0) - 3))

const formattedDate = computed(() =>
    props.article?.published_at
        ? new Date(props.article.published_at).toLocaleDateString('en-US', {
          year: 'numeric',
          month: 'short',
          day: 'numeric',
        })
        : ''
)

const thumbnail = computed(() =>
    props.article ? useArticleThumbnail(props.article) : {type: 'color' as const, color: 'var(--p-surface-800)'}
)

const {resolveImageUrl} = useStorageUrl()

const resolvedThumbnailUrl = computed(() => {
  const thumbResult = thumbnail.value
  if (thumbResult.type !== 'image') return null
  return resolveImageUrl(thumbResult.url)
})

interface Ripple {
  id: number;
  x: number;
  y: number;
  size: number
}

const ripples = ref<Ripple[]>([])
let rippleCounter = 0

function handleClick(event: MouseEvent) {
  if (props.loading) return
  const el = event.currentTarget as HTMLElement
  const rect = el.getBoundingClientRect()
  const size = Math.max(rect.width, rect.height) * 2
  const rippleX = event.clientX - rect.left - size / 2
  const rippleY = event.clientY - rect.top - size / 2
  const id = ++rippleCounter
  ripples.value.push({id, x: rippleX, y: rippleY, size})
  setTimeout(() => {
    const idx = ripples.value.findIndex(ripple => ripple.id === id)
    if (idx !== -1) ripples.value.splice(idx, 1)
  }, 700)
}
</script>

<template>
  <article
      class="group relative flex overflow-hidden rounded-lg border border-surface-200 bg-surface-100 dark:border-surface-800 dark:bg-surface-900"
      :class="loading ? 'cursor-default' : 'cursor-pointer opacity-85 transition-all duration-200 hover:opacity-100 hover:shadow-xl hover:shadow-black/10 dark:hover:shadow-black/40 hover:border-surface-300 dark:hover:border-surface-700'"
      @click="handleClick"
  >
    <template v-if="loading">
      <div class="w-1.5 shrink-0 bg-surface-200 dark:bg-surface-700 animate-pulse"/>
      <div class="flex flex-col w-full min-w-0">
        <div class="flex gap-2 sm:gap-4 px-4 pt-4 pb-2 min-w-0">
          <div class="flex flex-col gap-2 flex-1 min-w-0">
            <div class="flex items-center gap-2">
              <div class="h-[10px] w-[35%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse"/>
              <div class="h-[10px] w-[18%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse ml-auto"/>
            </div>
            <div class="h-[18px] w-[80%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse"/>
            <div class="h-[18px] w-[52%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse"/>
            <div class="h-[13px] w-[65%] rounded bg-surface-200 dark:bg-surface-700 animate-pulse"/>
          </div>
          <div class="w-16 h-16 sm:w-24 sm:h-24 rounded-lg bg-surface-200 dark:bg-surface-700 animate-pulse shrink-0 self-center"/>
        </div>
        <div class="px-4 pb-4 pt-2 border-t border-surface-200 dark:border-surface-800 flex gap-2">
          <div class="h-[22px] w-[70px] rounded-full bg-surface-200 dark:bg-surface-700 animate-pulse"/>
          <div class="h-[22px] w-[80px] rounded-full bg-surface-200 dark:bg-surface-700 animate-pulse"/>
          <div class="h-[22px] w-[55px] rounded-full bg-surface-200 dark:bg-surface-700 animate-pulse"/>
        </div>
      </div>
    </template>

    <template v-else-if="article">
      <div
          v-for="ripple in ripples"
          :key="ripple.id"
          class="ripple-circle absolute rounded-full bg-white/15 pointer-events-none"
          :style="{ left: `${ripple.x}px`, top: `${ripple.y}px`, width: `${ripple.size}px`, height: `${ripple.size}px` }"
      />

      <div
          v-if="article.featured_articles"
          data-testid="featured-bar"
          class="w-1.5 shrink-0 bg-amber-500 opacity-80 transition-opacity duration-200 group-hover:opacity-100"
      />

      <div class="flex flex-col w-full min-w-0">
        <div class="flex gap-2 sm:gap-4 px-4 pt-4 pb-2 min-w-0">
          <div class="flex flex-col gap-1.5 flex-1 min-w-0">

            <div class="flex flex-col sm:flex-row sm:items-center gap-1 sm:gap-2 min-w-0">
              <nuxt-link
                  v-if="article.article_categories"
                  :to="`/articles/browse?category=${article.article_categories.slug}`"
                  class="flex items-center gap-1.5 min-w-0 overflow-hidden"
              >
                <span
                    data-testid="category-dot"
                    class="w-2.5 h-2.5 rounded-full shrink-0 ring-2 ring-white/10"
                    :style="{ backgroundColor: article.article_categories.color ?? 'var(--p-surface-500)' }"
                />
                <span class="text-xs text-surface-700 dark:text-surface-300 truncate">{{
                    article.article_categories.name
                  }}</span>
              </nuxt-link>
              <span class="sm:ml-auto shrink-0 text-xs text-surface-600 dark:text-surface-400">{{ formattedDate }}</span>
            </div>

            <nuxt-link
                :to="`/articles/${article.slug}`"
                class="font-display text-lg font-semibold leading-snug line-clamp-2 group-hover:text-primary-400 transition-colors duration-200"
            >
              {{ article.title }}
            </nuxt-link>

            <span
                v-if="article.featured_articles?.featured_reason"
                data-testid="featured-reason"
                class="self-start max-w-full text-xs px-2 py-0.5 rounded-full border border-amber-500/50 text-amber-400 leading-none truncate"
            >
              {{ article.featured_articles.featured_reason }}
            </span>

            <p
                v-if="article.summary"
                data-testid="article-summary"
                class="text-sm text-surface-600 dark:text-surface-400 line-clamp-2"
            >
              {{ article.summary }}
            </p>

          </div>

          <div
              data-testid="article-thumbnail"
              class="w-16 h-16 sm:w-24 sm:h-24 shrink-0 rounded-lg overflow-hidden self-start"
              :style="thumbnail.type === 'color' ? { backgroundColor: thumbnail.color } : {}"
          >
            <img
                v-if="thumbnail.type === 'image' && resolvedThumbnailUrl"
                :src="resolvedThumbnailUrl"
                :alt="article.title"
                class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
            />
          </div>
        </div>

        <div class="px-4 pb-4 min-w-0">
          <div v-if="article.article_series" class="flex items-center gap-1.5 pb-2 min-w-0">
            <span class="text-xs text-surface-600 dark:text-surface-500 shrink-0">Part {{
                article.series_sequence_number
              }} of</span>
            <nuxt-link
                :to="`/articles/series/${article.article_series.slug}`"
                class="text-xs text-primary-400 truncate hover:underline"
            >
              {{ article.article_series.title }}
            </nuxt-link>
          </div>
          <div class="flex flex-wrap items-center gap-2 pt-2 border-t border-surface-200 dark:border-surface-800">
            <nuxt-link
                v-for="tagLink in visibleTags"
                :key="tagLink.article_tags.slug"
                :to="`/articles/browse?tag=${tagLink.article_tags.slug}`"
                class="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-surface-100 text-surface-700 dark:bg-surface-800 dark:text-surface-300 leading-none hover:bg-surface-200 dark:hover:bg-surface-700 transition-colors"
            >
              <icon v-if="tagLink.article_tags.icon" :name="tagLink.article_tags.icon" class="w-3.5 h-3.5 shrink-0"/>
              {{ tagLink.article_tags.name }}
            </nuxt-link>
            <span
                v-if="hiddenTagCount > 0"
                data-testid="hidden-tag-count"
                class="text-xs px-2.5 py-1 rounded-full bg-surface-100 text-surface-600 dark:bg-surface-800 dark:text-surface-500 leading-none"
            >
              +{{ hiddenTagCount }}
            </span>
          </div>
        </div>
      </div>
    </template>
  </article>
</template>

<style scoped>
@keyframes ripple-expand {
  from {
    transform: scale(0);
    opacity: 0.5;
  }
  to {
    transform: scale(1);
    opacity: 0;
  }
}

.ripple-circle {
  animation: ripple-expand 0.65s ease-out forwards;
}
</style>
