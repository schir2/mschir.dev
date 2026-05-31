<script lang="ts" setup>
import type { ArticleAdminListItem } from '#shared/types/Articles'

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
    .select('id, title, writing_stage, published_at, created_at, article_topics(name), article_series(title)')
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

      <p-column header="Topic">
        <template #body="{ data: row }">
          {{ row.article_topics?.name ?? '—' }}
        </template>
      </p-column>

      <p-column header="Series">
        <template #body="{ data: row }">
          {{ row.article_series?.title ?? '—' }}
        </template>
      </p-column>

      <p-column header="Status">
        <template #body="{ data: row }">
          <p-tag
            :value="row.published_at ? 'Published' : row.writing_stage"
            :severity="row.published_at ? 'success' : 'secondary'"
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
