<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Series' })

import { FilterMatchMode } from '@primevue/core/api'
import type { ArticleSeries } from '#shared/types/ArticleSeries'

const supabase = useSupabaseClient()
const confirm = useConfirm()
const toast = useToast()

const filters = ref({ global: { value: null as string | null, matchMode: FilterMatchMode.CONTAINS } })

const {
  data: seriesList,
  pending: seriesLoading,
  refresh: refreshSeries,
} = await useAsyncData<ArticleSeries[]>('admin-series', async () => {
  const { data, error } = await supabase
    .from('article_series')
    .select('id, title, slug, description, author, image_url, created_at, updated_at')
    .order('title', { ascending: true })

  if (error) throw error
  return data as ArticleSeries[]
}, { lazy: true })

function getSeriesImageUrl(imagePath: string | null): string | null {
  if (!imagePath) return null
  return supabase.storage.from('images').getPublicUrl(imagePath).data.publicUrl
}

function confirmDelete(seriesId: string) {
  confirm.require({
    header: 'Delete Series',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: () => deleteSeries(seriesId),
  })
}

async function deleteSeries(seriesId: string) {
  const { error } = await supabase
    .from('article_series')
    .delete()
    .eq('id', seriesId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Series deleted', life: 3000 })
  await refreshSeries()
}
</script>

<template>
  <div class="pb-8">
    <admin-page-header>
      <template #actions>
        <p-button label="New Series" rounded severity="secondary" @click="navigateTo('/admin/series/new')">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-progress-spinner v-if="seriesLoading" />

    <template v-else>
      <div class="flex justify-end mb-3">
        <p-input-text v-model="filters.global.value" placeholder="Search…" size="small" />
      </div>

      <p-data-table
        :value="seriesList ?? []"
        v-model:filters="filters"
        :global-filter-fields="['title', 'slug', 'description']"
        :rows="20"
        paginator
        size="small"
        striped-rows
        empty-message="No series found."
      >
        <p-column header="Image" style="width: 4rem">
          <template #body="{ data: row }">
            <img
              v-if="getSeriesImageUrl(row.image_url)"
              :src="getSeriesImageUrl(row.image_url)!"
              :alt="row.title"
              class="w-10 h-10 object-cover rounded"
            >
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column field="title" header="Title" :sortable="true">
          <template #body="{ data: row }">
            <nuxt-link
              :to="`/admin/series/${row.id}`"
              class="hover:text-primary hover:underline cursor-pointer"
            >{{ row.title }}</nuxt-link>
          </template>
        </p-column>

        <p-column field="slug" header="Slug" :sortable="true">
          <template #body="{ data: row }">
            <span class="text-muted-color font-mono text-xs">{{ row.slug || '—' }}</span>
          </template>
        </p-column>

        <p-column field="description" header="Description">
          <template #body="{ data: row }">
            <span v-if="row.description" class="text-sm line-clamp-1">{{ row.description }}</span>
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column header="" style="width: 4rem">
          <template #body="{ data: row }">
            <div class="flex gap-1 justify-end">
              <p-button
                text
                size="small"
                severity="danger"
                aria-label="Delete series"
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
