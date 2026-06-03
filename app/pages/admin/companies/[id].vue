<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'Edit Company' })

import { zodResolver } from '@primevue/forms/resolvers/zod'
import { CompanyUpdateSchema } from '~/schemas/CompanyUpdateSchema'
import type { Company } from '#shared/types/Company'

const route = useRoute()
const supabase = useSupabaseClient()
const toast = useToast()
const confirm = useConfirm()

const companyId = route.params.id as string

const { data: company, refresh } = await useAsyncData<Company>(`company-${companyId}`, async () => {
  const { data, error } = await supabase
    .from('companies')
    .select('id, name, url, logo_url')
    .eq('id', companyId)
    .single()
  if (error) throw error
  return data as Company
})

if (!company.value) {
  throw createError({ statusCode: 404, statusMessage: 'Company not found' })
}

const initialValues = {
  name: company.value.name,
  url: company.value.url ?? '',
}

const logoPath = ref<string | null>(company.value.logo_url)
const stagedLogoFile = ref<File | null>(null)
const logoPreviewUrl = ref<string | null>(
  company.value.logo_url
    ? supabase.storage.from('icons').getPublicUrl(company.value.logo_url).data.publicUrl
    : null
)

function onLogoFilePicked(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0] ?? null
  stagedLogoFile.value = file
  if (file) logoPreviewUrl.value = URL.createObjectURL(file)
}

const resolver = zodResolver(CompanyUpdateSchema)

async function onSubmit({ valid, values }: { valid: boolean; values: Record<string, unknown> }) {
  if (!valid) return

  let newLogoPath = logoPath.value
  if (stagedLogoFile.value) {
    try {
      newLogoPath = await useImageUpload('icons', 'company-logos', stagedLogoFile.value, logoPath.value ?? undefined)
    }
    catch (uploadError: unknown) {
      const message = uploadError instanceof Error ? uploadError.message : String(uploadError)
      toast.add({ severity: 'error', summary: 'Logo upload failed', detail: message, life: 4000 })
      return
    }
    finally {
      stagedLogoFile.value = null
    }
  }

  const { error } = await supabase
    .from('companies')
    .update({
      name: values.name as string,
      url: (values.url as string) || null,
      logo_url: newLogoPath,
    })
    .eq('id', companyId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Save failed', detail: error.message, life: 4000 })
    return
  }

  logoPath.value = newLogoPath
  toast.add({ severity: 'success', summary: 'Company saved', life: 3000 })
  await refresh()
}

function confirmDelete() {
  confirm.require({
    header: 'Delete Company',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: async () => {
      const { error } = await supabase.from('companies').delete().eq('id', companyId)
      if (error) {
        toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
        return
      }
      await navigateTo('/admin/companies')
    },
  })
}
</script>

<template>
  <div class="max-w-2xl mx-auto px-6 pt-6 pb-8">
    <p-confirm-dialog />

    <admin-page-header>
      <template #actions>
        <p-button label="All Companies" rounded severity="secondary" @click="navigateTo('/admin/companies')">
          <template #icon>
            <icon name="material-symbols:arrow-back" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-form :resolver="resolver" :initial-values="initialValues" class="flex flex-col gap-5" @submit="onSubmit">
      <p-form-field v-slot="$field" name="name" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Name</label>
        <p-input-text v-bind="$field" fluid />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="url" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Website URL</label>
        <p-input-text v-bind="$field" fluid placeholder="https://…" />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <div class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Logo</label>
        <div class="flex items-center gap-4">
          <img
            v-if="logoPreviewUrl"
            :src="logoPreviewUrl"
            alt="Company logo"
            class="w-16 h-16 object-contain rounded bg-surface-800 p-1"
          >
          <span v-else class="w-16 h-16 rounded bg-surface-800 flex items-center justify-center text-muted-color text-xs">No logo</span>
          <input type="file" accept="image/*" class="text-sm text-muted-color" @change="onLogoFilePicked">
        </div>
      </div>

      <div class="flex justify-between pt-2">
        <p-button type="submit" label="Save" rounded severity="secondary">
          <template #icon>
            <icon name="material-symbols:save" />
          </template>
        </p-button>
        <p-button label="Delete" rounded severity="danger" text @click="confirmDelete">
          <template #icon>
            <icon name="material-symbols:delete-outline" />
          </template>
        </p-button>
      </div>
    </p-form>
  </div>
</template>
