<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Categories' })

import { FilterMatchMode } from '@primevue/core/api'
import type { ArticleCategory } from '#shared/types/ArticleCategory'

const supabase = useSupabaseClient()
const confirm = useConfirm()
const toast = useToast()

const filters = ref({ global: { value: null as string | null, matchMode: FilterMatchMode.CONTAINS } })

const {
  data: categories,
  pending: categoriesLoading,
  refresh: refreshCategories,
} = await useAsyncData<ArticleCategory[]>('admin-categories', async () => {
  const { data, error } = await supabase
    .from('article_categories')
    .select('id, name, slug, color, description, image_url')
    .order('name', { ascending: true })

  if (error) throw error
  return data as ArticleCategory[]
}, { lazy: true })

function getCategoryImageUrl(imagePath: string | null): string | null {
  if (!imagePath) return null
  return supabase.storage.from('images').getPublicUrl(imagePath).data.publicUrl
}

function confirmDelete(categoryId: string) {
  confirm.require({
    header: 'Delete Category',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: () => deleteCategory(categoryId),
  })
}

async function deleteCategory(categoryId: string) {
  const { error } = await supabase
    .from('article_categories')
    .delete()
    .eq('id', categoryId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Category deleted', life: 3000 })
  await refreshCategories()
}
</script>

<template>
  <div class="pb-8">
    <p-confirm-dialog />

    <admin-page-header>
      <template #actions>
        <p-button label="New Category" rounded severity="secondary" @click="navigateTo('/admin/categories/new')">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-progress-spinner v-if="categoriesLoading" />

    <template v-else>
      <div class="flex justify-end mb-3">
        <p-input-text v-model="filters.global.value" placeholder="Search…" size="small" />
      </div>

      <p-data-table
        :value="categories ?? []"
        v-model:filters="filters"
        :global-filter-fields="['name', 'slug', 'description']"
        :rows="20"
        paginator
        size="small"
        striped-rows
        empty-message="No categories found."
      >
        <p-column header="Image" style="width: 4rem">
          <template #body="{ data: row }">
            <img
              v-if="getCategoryImageUrl(row.image_url)"
              :src="getCategoryImageUrl(row.image_url)!"
              :alt="row.name"
              class="w-10 h-10 object-cover rounded"
            >
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column field="name" header="Name" :sortable="true">
          <template #body="{ data: row }">
            <nuxt-link
              :to="`/admin/categories/${row.id}`"
              class="hover:text-primary hover:underline cursor-pointer"
            >{{ row.name }}</nuxt-link>
          </template>
        </p-column>

        <p-column field="slug" header="Slug" :sortable="true">
          <template #body="{ data: row }">
            <span class="text-muted-color font-mono text-xs">{{ row.slug || '—' }}</span>
          </template>
        </p-column>

        <p-column header="Color" style="width: 8rem">
          <template #body="{ data: row }">
            <div v-if="row.color" class="flex items-center gap-2">
              <span
                class="inline-block w-4 h-4 rounded-full border border-surface-400 flex-shrink-0"
                :style="{ backgroundColor: row.color }"
              />
              <span class="text-muted-color font-mono text-xs">{{ row.color }}</span>
            </div>
            <span v-else class="text-muted-color">—</span>
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
                aria-label="Delete category"
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
