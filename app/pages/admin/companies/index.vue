<script lang="ts" setup>
import type { Company, CompanyInsert, CompanyUpdate } from '#shared/types/Company'

const supabase = useSupabaseClient()
const confirm = useConfirm()
const toast = useToast()

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

/** Local list that may contain an unsaved new row (no id yet). */
const localCompanies = computed<(Company | CompanyInsert)[]>(() => companies.value ?? [])
const pendingNewRow = ref<CompanyInsert | null>(null)

/** Rows shown in the table — pending new row prepended when present. */
const tableRows = computed<(Company | CompanyInsert)[]>(() => {
  if (pendingNewRow.value) {
    return [pendingNewRow.value, ...localCompanies.value]
  }
  return localCompanies.value
})

function getLogoPublicUrl(logoPath: string | null | undefined): string | null {
  if (!logoPath) return null
  return supabase.storage.from('icons').getPublicUrl(logoPath).data.publicUrl
}

function addNewRow() {
  if (pendingNewRow.value) return // already adding one
  pendingNewRow.value = { name: '', url: null, logo_url: null }
}

/** File picked in the editor slot — held until the row is saved. */
const stagedLogoFile = ref<File | null>(null)

function onLogoFilePicked(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0] ?? null
  stagedLogoFile.value = file
}

async function onRowEditSave(event: { newData: Company | CompanyInsert }) {
  const rowData = event.newData

  // Determine if this is a new (unsaved) row — new rows have no `id`.
  const isNew = !('id' in rowData) || !(rowData as Company).id

  let logoPath: string | null = (rowData as Company).logo_url ?? null

  // Upload a new logo if the user picked a file.
  if (stagedLogoFile.value) {
    try {
      const existingPath = isNew ? undefined : ((rowData as Company).logo_url ?? undefined)
      logoPath = await useImageUpload('icons', 'company-logos', stagedLogoFile.value, existingPath)
    }
    catch (uploadError: unknown) {
      const message = uploadError instanceof Error ? uploadError.message : String(uploadError)
      toast.add({ severity: 'error', summary: 'Logo upload failed', detail: message, life: 5000 })
      return
    }
    finally {
      stagedLogoFile.value = null
    }
  }

  if (isNew) {
    const insertPayload: CompanyInsert = {
      name: rowData.name,
      url: (rowData as CompanyInsert).url ?? null,
      logo_url: logoPath,
    }

    const { error } = await supabase.from('companies').insert(insertPayload)

    if (error) {
      toast.add({ severity: 'error', summary: 'Create failed', detail: error.message, life: 4000 })
      return
    }

    pendingNewRow.value = null
    toast.add({ severity: 'success', summary: 'Company created', life: 3000 })
  }
  else {
    const company = rowData as Company
    const updatePayload: CompanyUpdate = {
      name: company.name,
      url: company.url,
      logo_url: logoPath,
    }

    const { error } = await supabase
      .from('companies')
      .update(updatePayload)
      .eq('id', company.id)

    if (error) {
      toast.add({ severity: 'error', summary: 'Update failed', detail: error.message, life: 4000 })
      return
    }

    toast.add({ severity: 'success', summary: 'Company updated', life: 3000 })
  }

  await refreshCompanies()
}

function onRowEditCancel() {
  // If the cancelled row was the pending new row, remove it.
  pendingNewRow.value = null
  stagedLogoFile.value = null
}

function confirmDelete(event: MouseEvent, companyId: string) {
  confirm.require({
    target: event.currentTarget as HTMLElement,
    message: 'Delete this company? This cannot be undone.',
    icon: 'pi pi-exclamation-triangle',
    acceptClass: 'p-button-danger',
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
  <div class="p-6">
    <p-confirm-popup />

    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold">Companies</h1>
      <p-button
        label="New Company"
        icon="pi pi-plus"
        :disabled="!!pendingNewRow"
        @click="addNewRow"
      />
    </div>

    <p-progress-spinner v-if="companiesLoading" />

    <p-data-table
      v-else
      :value="tableRows"
      edit-mode="row"
      data-key="id"
      empty-message="No companies found."
      @row-edit-save="onRowEditSave"
      @row-edit-cancel="onRowEditCancel"
    >
      <!-- Logo column -->
      <p-column header="Logo" style="width: 80px">
        <template #body="{ data: row }">
          <img
            v-if="getLogoPublicUrl((row as Company).logo_url)"
            :src="getLogoPublicUrl((row as Company).logo_url)!"
            :alt="row.name"
            class="logo-thumbnail"
          >
          <span v-else class="text-muted-color">—</span>
        </template>
        <template #editor="{ data: row }">
          <div class="flex flex-col gap-1">
            <img
              v-if="getLogoPublicUrl((row as Company).logo_url) && !stagedLogoFile"
              :src="getLogoPublicUrl((row as Company).logo_url)!"
              :alt="row.name"
              class="logo-thumbnail"
            >
            <input
              type="file"
              accept="image/*"
              class="logo-file-input"
              @change="onLogoFilePicked"
            >
          </div>
        </template>
      </p-column>

      <!-- Name column -->
      <p-column field="name" header="Name">
        <template #editor="{ data: row }">
          <p-input-text v-model="row.name" fluid />
        </template>
      </p-column>

      <!-- URL column -->
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
        <template #editor="{ data: row }">
          <p-input-text v-model="row.url" fluid placeholder="https://…" />
        </template>
      </p-column>

      <!-- Row editor controls -->
      <p-column :row-editor="true" style="width: 100px; text-align: right" />

      <!-- Delete column — only shown for persisted rows -->
      <p-column header="" style="width: 60px">
        <template #body="{ data: row }">
          <p-button
            v-if="(row as Company).id"
            icon="pi pi-trash"
            size="small"
            text
            severity="danger"
            @click="confirmDelete($event, (row as Company).id)"
          />
        </template>
      </p-column>
    </p-data-table>
  </div>
</template>

<style scoped>
.logo-thumbnail {
  width: 40px;
  height: 40px;
  object-fit: contain;
  border-radius: 4px;
  background-color: var(--p-surface-100);
}

.logo-file-input {
  font-size: 0.75rem;
  color: var(--p-text-muted-color);
}
</style>
