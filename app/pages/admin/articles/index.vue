<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Articles' })

import { FilterMatchMode } from '@primevue/core/api'
import type { ArticleAdminListItem } from '#shared/types/Article'

const supabase = useSupabaseClient()
const confirm = useConfirm()
const toast = useToast()

const filters = ref({ global: { value: null as string | null, matchMode: FilterMatchMode.CONTAINS } })

const {
  data: articles,
  pending: articlesLoading,
  refresh: refreshArticles,
} = await useAsyncData<ArticleAdminListItem[]>('admin-articles', async () => {
  const { data, error } = await supabase
    .from('articles')
    .select('id, title, slug, writing_stage, published_at, archived_at, created_at, article_categories(name), article_series(title), featured_articles(id)')
    .order('created_at', { ascending: false })

  if (error) throw error
  return data as ArticleAdminListItem[]
}, { lazy: true })

function confirmDelete(articleId: string) {
  confirm.require({
    header: 'Delete Article',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: () => deleteArticle(articleId),
  })
}

async function deleteArticle(articleId: string) {
  const { error } = await supabase
    .from('articles')
    .delete()
    .eq('id', articleId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Article deleted', life: 3000 })
  await refreshArticles()
}
</script>

<template>
  <div class="pb-8">
    <admin-page-header>
      <template #actions>
        <p-button label="New Article" rounded severity="secondary" @click="navigateTo('/admin/articles/new')">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-progress-spinner v-if="articlesLoading" />

    <template v-else>
      <div class="flex justify-end mb-3">
        <p-input-text v-model="filters.global.value" placeholder="Search…" size="small" />
      </div>

      <p-data-table
        :value="articles ?? []"
        v-model:filters="filters"
        :global-filter-fields="['title']"
        :rows="20"
        paginator
        size="small"
        striped-rows
        empty-message="No articles found."
      >
        <p-column field="title" header="Title" :sortable="true">
          <template #body="{ data: row }">
            <nuxt-link
              :to="`/admin/articles/${row.id}`"
              class="hover:text-primary hover:underline cursor-pointer"
            >{{ row.title }}</nuxt-link>
          </template>
        </p-column>

        <p-column header="Category">
          <template #body="{ data: row }">
            {{ row.article_categories?.name ?? '—' }}
          </template>
        </p-column>

        <p-column header="Series">
          <template #body="{ data: row }">
            {{ row.article_series?.title ?? '—' }}
          </template>
        </p-column>

        <p-column header="Featured">
          <template #body="{ data: row }">
            <p-tag v-if="row.featured_articles !== null" value="Featured" severity="warn" />
            <span v-else>—</span>
          </template>
        </p-column>

        <p-column header="Status" :sortable="true" sort-field="published_at">
          <template #body="{ data: row }">
            <p-tag
              :value="deriveArticleStatus(row.published_at, row.archived_at, row.writing_stage).label"
              :severity="deriveArticleStatus(row.published_at, row.archived_at, row.writing_stage).severity"
            />
          </template>
        </p-column>

        <p-column field="created_at" header="Created" :sortable="true">
          <template #body="{ data: row }">
            {{ new Date(row.created_at).toLocaleDateString() }}
          </template>
        </p-column>

        <p-column header="" style="width: 5rem">
          <template #body="{ data: row }">
            <div class="flex gap-1 justify-end">
              <p-button
                v-if="row.published_at"
                text
                size="small"
                severity="secondary"
                aria-label="View article"
                @click="() => window.open(`/articles/${row.slug}`, '_blank', 'noopener,noreferrer')"
              >
                <template #icon>
                  <icon name="material-symbols:visibility-outline" />
                </template>
              </p-button>
              <p-button
                text
                size="small"
                severity="danger"
                aria-label="Delete article"
                @click="confirmDelete(row.id)"
              >
                <template #icon>
                  <icon name="material-symbols:delete-outline" />
                </template>
              </p-button>
            </div>
          </template>
        </p-column>
      </p-data-table>
    </template>
  </div>
</template>
