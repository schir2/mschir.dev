<script lang="ts" setup>
import { ARTICLE_CARD_SELECT } from '#shared/types/Article'
import type { ArticleCardItem, ArticleTag } from '#shared/types/Article'
import type { ArticleCategory } from '#shared/types/ArticleCategory'

definePageMeta({title: 'Browse Articles', layout: 'page'})

usePageSeo({
  title: 'Browse Articles',
  description: 'Browse all articles by Marek Schir. Filter by category and tags to find content on software development, integrations, and more.',
})

useSchemaOrg([
  defineBreadcrumb({
    itemListElement: [
      { name: 'Articles', item: '/articles' },
      { name: 'Browse' },
    ],
  }),
])

const supabase = useSupabaseClient()
const route = useRoute()
const router = useRouter()

const {
  data: allArticles,
  pending: articlesPending,
  error: articlesError,
} = useAsyncData<ArticleCardItem[]>('browse-articles', async () => {
  const { data, error } = await supabase
    .from('articles')
    .select(ARTICLE_CARD_SELECT)
    .not('published_at', 'is', null)
    .is('archived_at', null)
    .order('published_at', { ascending: false })
  if (error) throw error
  return (data ?? []) as ArticleCardItem[]
}, { lazy: true })

const {
  data: categories,
  error: categoriesError,
} = useAsyncData<ArticleCategory[]>('browse-categories', async () => {
  const { data, error } = await supabase
    .from('article_categories')
    .select('id, name, slug, description')
    .order('name')
  if (error) throw error
  return (data ?? []) as ArticleCategory[]
}, { lazy: true })

const {
  data: tags,
  error: tagsError,
} = useAsyncData<ArticleTag[]>('browse-tags', async () => {
  const { data, error } = await supabase
    .from('article_tags')
    .select('id, name, slug, icon, article_tags_links!inner(article_id)')
    .order('name')
  if (error) throw error
  return (data ?? []) as unknown as ArticleTag[]
}, { lazy: true })

const layout = ref<'list' | 'grid'>('list')

const activeCategory = ref<string | null>((route.query.category as string) ?? null)
const activeTags = ref<string[]>(
  route.query.tag
    ? (Array.isArray(route.query.tag) ? (route.query.tag as string[]) : [route.query.tag as string])
    : [],
)

const filteredArticles = computed<ArticleCardItem[]>(() =>
  filterArticles(allArticles.value ?? [], activeCategory.value, activeTags.value),
)

function onCategoryUpdate(slug: string | null): void {
  activeCategory.value = slug
  router.replace({
    query: {
      ...(slug ? { category: slug } : {}),
      ...(activeTags.value.length ? { tag: activeTags.value } : {}),
    },
  })
}

function onTagsUpdate(slugs: string[]): void {
  activeTags.value = slugs
  router.replace({
    query: {
      ...(activeCategory.value ? { category: activeCategory.value } : {}),
      ...(slugs.length ? { tag: slugs } : {}),
    },
  })
}
</script>

<template>
  <div class="flex flex-col gap-8">
    <article-page-header
      :crumbs="[{ label: 'Articles', route: '/articles' }, { label: 'Browse' }]"
      title="Browse Articles"
    />

    <section>
      <p v-if="categoriesError || tagsError" class="text-red-500">Failed to load filters.</p>
      <article-category-tag-filter
        v-else
        :categories="categories ?? []"
        :tags="tags ?? []"
        :model-category="activeCategory"
        :model-tags="activeTags"
        @update:model-category="onCategoryUpdate"
        @update:model-tags="onTagsUpdate"
      />
    </section>

    <section class="flex flex-col gap-4">
      <div class="flex items-center justify-end gap-1">
        <p-button
          :severity="layout === 'list' ? 'primary' : 'secondary'"
          variant="text"
          size="small"
          aria-label="Single column"
          @click="layout = 'list'"
        >
          <template #icon>
            <icon name="material-symbols:view-agenda-outline" class="text-lg" />
          </template>
        </p-button>
        <p-button
          :severity="layout === 'grid' ? 'primary' : 'secondary'"
          variant="text"
          size="small"
          aria-label="Two columns"
          @click="layout = 'grid'"
        >
          <template #icon>
            <icon name="material-symbols:grid-view-outline" class="text-lg" />
          </template>
        </p-button>
      </div>

      <div v-if="articlesPending" class="flex flex-col gap-4">
        <article-card v-for="n in 3" :key="n" loading />
      </div>
      <p v-else-if="articlesError">{{ articlesError.message }}</p>
      <p-data-view v-else :value="filteredArticles" :layout="layout">
        <template #list="slotProps">
          <div class="flex flex-col gap-4">
            <article-card
              v-for="article in slotProps.items"
              :key="article.id"
              :article="article"
            />
          </div>
        </template>
        <template #grid="slotProps">
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <article-card
              v-for="article in slotProps.items"
              :key="article.id"
              :article="article"
            />
          </div>
        </template>
        <template #empty>
          <p class="text-color-secondary">No articles match the selected filters.</p>
        </template>
      </p-data-view>
    </section>
  </div>
</template>
