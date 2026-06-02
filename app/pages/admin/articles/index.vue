<script lang="ts" setup>
import type { ArticleAdminListItem } from '#shared/types/Article'

const supabase = useSupabaseClient()
const confirm = useConfirm()
const toast = useToast()

const {
  data: articles,
  pending: articlesLoading,
  refresh: refreshArticles,
} = await useAsyncData<ArticleAdminListItem[]>('admin-articles', async () => {
  const { data, error } = await supabase
    .from('articles')
    .select('id, title, writing_stage, published_at, archived_at, created_at, article_categories(name), article_series(title), featured_articles(id)')
    .order('created_at', { ascending: false })

  if (error) throw error
  return data as ArticleAdminListItem[]
}, { lazy: true })

function confirmDelete(event: MouseEvent, articleId: string) {
  confirm.require({
    target: event.currentTarget as HTMLElement,
    message: 'Delete this article? This cannot be undone.',
    icon: 'pi pi-exclamation-triangle',
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
  <div class="p-6">
    <p-confirm-popup />

    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold">Articles</h1>
      <p-button
        label="New Article"
        icon="pi pi-plus"
        @click="$router.push('/admin/articles/new')"
      />
    </div>

    <p-progress-spinner v-if="articlesLoading" />

    <p-data-table
      v-else
      :value="articles ?? []"
      :rows="20"
      paginator
      empty-message="No articles found."
    >
      <p-column field="title" header="Title" />

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

      <p-column header="Status">
        <template #body="{ data: row }">
          <p-tag
            :value="deriveArticleStatus(row.published_at, row.archived_at, row.writing_stage).label"
            :severity="deriveArticleStatus(row.published_at, row.archived_at, row.writing_stage).severity"
          />
        </template>
      </p-column>

      <p-column header="Created">
        <template #body="{ data: row }">
          {{ new Date(row.created_at).toLocaleDateString() }}
        </template>
      </p-column>

      <p-column header="Actions">
        <template #body="{ data: row }">
          <div class="flex gap-2">
            <p-button
              icon="pi pi-pencil"
              size="small"
              text
              @click="$router.push(`/admin/articles/${row.id}`)"
            />
            <p-button
              icon="pi pi-trash"
              size="small"
              text
              severity="danger"
              @click="confirmDelete($event, row.id)"
            />
          </div>
        </template>
      </p-column>
    </p-data-table>
  </div>
</template>
