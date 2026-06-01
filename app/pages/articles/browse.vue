<script lang="ts" setup>
import type { ArticleCardItem, ArticleCategory, ArticleTag } from '#shared/types/Article'

const supabase = useSupabaseClient()
const route = useRoute()
const router = useRouter()

const articleCardSelect = 'id, title, slug, summary, published_at, image_url, series_id, series_sequence_number, article_categories(name, slug, color, image_url), article_tags_links(article_tags(name, slug)), article_series(title, slug, image_url), featured_articles(id, featured_reason)'

const {
  data: allArticles,
  pending: articlesPending,
  error: articlesError,
} = useAsyncData<ArticleCardItem[]>('browse-articles', async () => {
  const { data, error } = await supabase
    .from('articles')
    .select(articleCardSelect)
    .not('published_at', 'is', null)
    .is('archived_at', null)
    .order('published_at', { ascending: false })
  if (error) throw error
  return (data ?? []) as ArticleCardItem[]
}, { lazy: true })

const {
  data: categories,
  pending: categoriesPending,
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
  pending: tagsPending,
  error: tagsError,
} = useAsyncData<ArticleTag[]>('browse-tags', async () => {
  const { data, error } = await supabase
    .from('article_tags')
    .select('id, name, slug')
    .order('name')
  if (error) throw error
  return (data ?? []) as ArticleTag[]
}, { lazy: true })

const listColumns = ref<1 | 2>(1)

const activeCategory = ref<string | null>((route.query.category as string) ?? null)
const activeTags = ref<string[]>(
  route.query.tag
    ? (Array.isArray(route.query.tag) ? (route.query.tag as string[]) : [route.query.tag as string])
    : [],
)

const filteredArticles = computed(() =>
  filterArticles(allArticles.value ?? [], activeCategory.value, activeTags.value),
)

function onCategoryUpdate(slug: string | null) {
  activeCategory.value = slug
  router.replace({
    query: {
      ...(slug ? { category: slug } : {}),
      ...(activeTags.value.length ? { tag: activeTags.value } : {}),
    },
  })
}

function onTagsUpdate(slugs: string[]) {
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
  <div class="max-w-3xl mx-auto px-6 pt-6 pb-12 flex flex-col gap-8">
    <header class="flex flex-col gap-2">
      <article-breadcrumb :crumbs="[{ label: 'Articles', to: '/articles' }, { label: 'Browse' }]" />
      <h1 class="text-4xl font-bold">Browse Articles</h1>
    </header>

    <section v-if="!categoriesPending && !tagsPending" class="flex flex-col gap-4">
      <p v-if="categoriesError || tagsError" class="text-red-500">Failed to load filters.</p>
      <category-tag-filter
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
          :severity="listColumns === 1 ? 'primary' : 'secondary'"
          variant="text"
          size="small"
          aria-label="Single column"
          @click="listColumns = 1"
        >
          <icon name="material-symbols:view-agenda-outline" />
        </p-button>
        <p-button
          :severity="listColumns === 2 ? 'primary' : 'secondary'"
          variant="text"
          size="small"
          aria-label="Two columns"
          @click="listColumns = 2"
        >
          <icon name="material-symbols:grid-view-outline" />
        </p-button>
      </div>
      <p-progress-spinner v-if="articlesPending" />
      <p v-else-if="articlesError">{{ articlesError.message }}</p>
      <p v-else-if="filteredArticles.length === 0" class="text-color-secondary">
        No articles match the selected filters.
      </p>
      <div
        v-else
        :class="listColumns === 2 ? 'grid grid-cols-1 sm:grid-cols-2 gap-3' : 'flex flex-col gap-3'"
      >
        <article-card
          v-for="article in filteredArticles"
          :key="article.id"
          :article="article"
        />
      </div>
    </section>
  </div>
</template>
