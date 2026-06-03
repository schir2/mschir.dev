<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'New Company' })

import { zodResolver } from '@primevue/forms/resolvers/zod'
import { CompanyInsertSchema } from '~/schemas/CompanyInsertSchema'

const supabase = useSupabaseClient()
const toast = useToast()
const { previewUrl: logoPreviewUrl, onFilePicked: onLogoFilePicked, uploadAndGet } = useAdminImageField('icons', 'company-logos')

const resolver = zodResolver(CompanyInsertSchema)

async function onSubmit({ valid, values }: { valid: boolean; values: Record<string, unknown> }) {
  if (!valid) return

  let logoPath: string | null = null
  try {
    logoPath = await uploadAndGet(null)
  }
  catch {
    return
  }

  const { data, error } = await supabase
    .from('companies')
    .insert({
      name: values.name as string,
      url: (values.url as string) || null,
      logo_url: logoPath,
    })
    .select('id')
    .single()

  if (error) {
    toast.add({ severity: 'error', summary: 'Create failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Company created', life: 3000 })
  await navigateTo(`/admin/companies/${data.id}`)
}
</script>

<template>
  <div class="max-w-2xl mx-auto px-6 pt-6 pb-8">
    <admin-page-header>
      <template #actions>
        <p-button label="All Companies" rounded severity="secondary" @click="navigateTo('/admin/companies')">
          <template #icon>
            <icon name="material-symbols:arrow-back" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-form :resolver="resolver" class="flex flex-col gap-5" @submit="onSubmit">
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
            alt="Logo preview"
            class="w-16 h-16 object-contain rounded bg-surface-800 p-1"
          >
          <input type="file" accept="image/*" class="text-sm text-muted-color" @change="onLogoFilePicked">
        </div>
      </div>

      <div class="pt-2">
        <p-button type="submit" label="Create Company" rounded severity="secondary">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </div>
    </p-form>
  </div>
</template>
