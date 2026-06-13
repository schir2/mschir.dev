<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Articles' })

import { FilterMatchMode } from '@primevue/core/api'
import type { ArticleAdminListItem } from '#shared/types/Article'

const supabase = useSupabaseClient()

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

const { confirmDelete } = useAdminDelete('articles', 'Article', refreshArticles)
</script>

<template>
  <div class="flex flex-col gap-8 pb-8">
    <admin-page-header>
      <template #actions>
        <p-button label="New Article" rounded severity="secondary" @click="navigateTo('/admin/articles/new')">
          <template #icon>
            <icon name="material-symbols:add-circle" class="text-lg" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-progress-spinner v-if="articlesLoading" />

    <div v-else class="flex flex-col gap-4">
      <div class="flex justify-end">
        <p-input-text v-model="filters.global.value" placeholder="Search…" />
      </div>

      <p-data-table
        :value="articles ?? []"
        v-model:filters="filters"
        :global-filter-fields="['title']"
        :rows="20"
        paginator

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
              <nuxt-link
                v-if="row.published_at"
                :to="`/articles/${row.slug}`"
                target="_blank"
                rel="noopener noreferrer"
              >
                <p-button text severity="secondary" aria-label="View article">
                  <template #icon>
                    <icon name="material-symbols:visibility-outline" class="text-lg" />
                  </template>
                </p-button>
              </nuxt-link>
              <p-button
                text

                severity="danger"
                aria-label="Delete article"
                @click="confirmDelete(row.id)"
              >
                <template #icon>
                  <icon name="material-symbols:delete-outline" class="text-lg" />
                </template>
              </p-button>
            </div>
          </template>
        </p-column>
      </p-data-table>
    </div>
  </div>
</template>
