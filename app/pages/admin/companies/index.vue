<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Companies' })

import { FilterMatchMode } from '@primevue/core/api'
import type { Company } from '#shared/types/Company'

const supabase = useSupabaseClient()
const confirm = useConfirm()
const toast = useToast()

const filters = ref({ global: { value: null as string | null, matchMode: FilterMatchMode.CONTAINS } })

const {
  data: companies,
  pending: companiesLoading,
  refresh: refreshCompanies,
} = await useAsyncData<Company[]>('admin-companies', async () => {
  const { data, error } = await supabase
    .from('companies')
    .select('id, name, url, logo_url')
    .order('name', { ascending: true })

  if (error) throw error
  return data as Company[]
}, { lazy: true })

function getLogoPublicUrl(logoPath: string | null): string | null {
  if (!logoPath) return null
  return supabase.storage.from('icons').getPublicUrl(logoPath).data.publicUrl
}

function confirmDelete(companyId: string) {
  confirm.require({
    header: 'Delete Company',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptProps: { severity: 'danger' },
    rejectProps: { severity: 'secondary', outlined: true },
    accept: () => deleteCompany(companyId),
  })
}

async function deleteCompany(companyId: string) {
  const { error } = await supabase
    .from('companies')
    .delete()
    .eq('id', companyId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Company deleted', life: 3000 })
  await refreshCompanies()
}
</script>

<template>
  <div class="pb-8">
    <admin-page-header>
      <template #actions>
        <p-button label="New Company" rounded severity="secondary" @click="navigateTo('/admin/companies/new')">
          <template #icon>
            <icon name="material-symbols:add-circle" class="text-lg" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-progress-spinner v-if="companiesLoading" />

    <template v-else>
      <div class="flex justify-end mb-3">
        <p-input-text v-model="filters.global.value" placeholder="Search…" />
      </div>

      <p-data-table
        :value="companies ?? []"
        v-model:filters="filters"
        :global-filter-fields="['name', 'url']"
        :rows="20"
        paginator

        striped-rows
        empty-message="No companies found."
      >
        <p-column header="Logo" style="width: 4rem">
          <template #body="{ data: row }">
            <img
              v-if="getLogoPublicUrl(row.logo_url)"
              :src="getLogoPublicUrl(row.logo_url)!"
              :alt="row.name"
              class="w-10 h-10 object-contain rounded bg-surface-800"
            >
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column field="name" header="Name" :sortable="true">
          <template #body="{ data: row }">
            <nuxt-link
              :to="`/admin/companies/${row.id}`"
              class="hover:text-primary hover:underline cursor-pointer"
            >{{ row.name }}</nuxt-link>
          </template>
        </p-column>

        <p-column field="url" header="URL">
          <template #body="{ data: row }">
            <a
              v-if="row.url"
              :href="row.url"
              target="_blank"
              rel="noopener noreferrer"
              class="text-primary underline"
            >{{ row.url }}</a>
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column header="" style="width: 4rem">
          <template #body="{ data: row }">
            <div class="flex gap-1 justify-end">
              <p-button
                text

                severity="danger"
                aria-label="Delete company"
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
    </template>
  </div>
</template>
