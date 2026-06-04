<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'New Category' })

import { zodResolver } from '@primevue/forms/resolvers/zod'
import { ArticleCategoryInsertSchema } from '~/schemas/ArticleCategoryInsertSchema'
import { normalizeColor } from '~/utils/normalizeColor'

const supabase = useSupabaseClient()
const toast = useToast()
const { previewUrl: imagePreviewUrl, onFilePicked: onImageFilePicked, uploadAndGet } = useAdminImageField('images', 'category-images')

const colorValue = ref<string>('')

const resolver = zodResolver(ArticleCategoryInsertSchema)

async function onSubmit({ valid, values }: { valid: boolean; values: Record<string, unknown> }) {
  if (!valid) return

  let imagePath: string | null = null
  try {
    imagePath = await uploadAndGet(null)
  }
  catch {
    return
  }

  const { data, error } = await supabase
    .from('article_categories')
    .insert({
      name: values.name as string,
      slug: values.slug as string,
      description: (values.description as string) || null,
      color: normalizeColor(colorValue.value),
      image_url: imagePath,
    })
    .select('id')
    .single()

  if (error) {
    toast.add({ severity: 'error', summary: 'Create failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Category created', life: 3000 })
  await navigateTo(`/admin/categories/${data.id}`)
}
</script>

<template>
  <div class="flex flex-col gap-8 max-w-2xl mx-auto px-6 pb-8">
    <admin-page-header>
      <template #actions>
        <p-button label="All Categories" rounded severity="secondary" @click="navigateTo('/admin/categories')">
          <template #icon>
            <icon name="material-symbols:arrow-back" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-form :resolver="resolver" class="flex flex-col gap-6" @submit="onSubmit">
      <p-form-field v-slot="$field" name="name" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Name</label>
        <p-input-text v-bind="$field" fluid />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="slug" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Slug</label>
        <p-input-text v-bind="$field" fluid placeholder="e.g. software-development" class="font-mono" />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="description" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Description</label>
        <p-textarea v-bind="$field" fluid rows="3" auto-resize placeholder="Short description…" />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <div class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Color</label>
        <div class="flex items-center gap-4">
          <p-color-picker v-model="colorValue" />
          <span class="text-muted-color font-mono text-sm">{{ normalizeColor(colorValue) ?? 'none' }}</span>
        </div>
      </div>

      <div class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Image</label>
        <div class="flex items-center gap-4">
          <img
            v-if="imagePreviewUrl"
            :src="imagePreviewUrl"
            alt="Image preview"
            class="w-16 h-16 object-cover rounded"
          >
          <input type="file" accept="image/*" class="text-sm text-muted-color" @change="onImageFilePicked">
        </div>
      </div>

      <div class="pt-2">
        <p-button type="submit" label="Create Category" rounded severity="secondary">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </div>
    </p-form>
  </div>
</template>
