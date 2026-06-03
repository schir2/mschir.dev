<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'Edit Category' })

import { zodResolver } from '@primevue/forms/resolvers/zod'
import { ArticleCategoryUpdateSchema } from '~/schemas/ArticleCategoryUpdateSchema'
import type { ArticleCategory } from '#shared/types/ArticleCategory'

const route = useRoute()
const supabase = useSupabaseClient()
const toast = useToast()
const confirm = useConfirm()

const categoryId = route.params.id as string

const { data: category, refresh } = await useAsyncData<ArticleCategory>(`category-${categoryId}`, async () => {
  const { data, error } = await supabase
    .from('article_categories')
    .select('id, name, slug, color, description, image_url')
    .eq('id', categoryId)
    .single()
  if (error) throw error
  return data as ArticleCategory
})

if (!category.value) {
  throw createError({ statusCode: 404, statusMessage: 'Category not found' })
}

const initialValues = {
  name: category.value.name,
  slug: category.value.slug,
  description: category.value.description ?? '',
}

const colorValue = ref<string>(category.value.color ?? '')
const imagePath = ref<string | null>(category.value.image_url)
const stagedImageFile = ref<File | null>(null)
const imagePreviewUrl = ref<string | null>(
  category.value.image_url
    ? supabase.storage.from('images').getPublicUrl(category.value.image_url).data.publicUrl
    : null
)

function onImageFilePicked(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0] ?? null
  stagedImageFile.value = file
  if (file) imagePreviewUrl.value = URL.createObjectURL(file)
}

function normalizeColor(raw: string): string | null {
  if (!raw || raw.trim() === '') return null
  return raw.startsWith('#') ? raw : `#${raw}`
}

const resolver = zodResolver(ArticleCategoryUpdateSchema)

async function onSubmit({ valid, values }: { valid: boolean; values: Record<string, unknown> }) {
  if (!valid) return

  let newImagePath = imagePath.value
  if (stagedImageFile.value) {
    try {
      newImagePath = await useImageUpload('images', 'category-images', stagedImageFile.value, imagePath.value ?? undefined)
    }
    catch (uploadError: unknown) {
      const message = uploadError instanceof Error ? uploadError.message : String(uploadError)
      toast.add({ severity: 'error', summary: 'Image upload failed', detail: message, life: 4000 })
      return
    }
    finally {
      stagedImageFile.value = null
    }
  }

  const { error } = await supabase
    .from('article_categories')
    .update({
      name: values.name as string,
      slug: values.slug as string,
      description: (values.description as string) || null,
      color: normalizeColor(colorValue.value),
      image_url: newImagePath,
    })
    .eq('id', categoryId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Save failed', detail: error.message, life: 4000 })
    return
  }

  imagePath.value = newImagePath
  toast.add({ severity: 'success', summary: 'Category saved', life: 3000 })
  await refresh()
}

function confirmDelete() {
  confirm.require({
    header: 'Delete Category',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: async () => {
      const { error } = await supabase.from('article_categories').delete().eq('id', categoryId)
      if (error) {
        toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
        return
      }
      await navigateTo('/admin/categories')
    },
  })
}
</script>

<template>
  <div class="max-w-2xl mx-auto px-6 pt-6 pb-8">
    <p-confirm-dialog />

    <admin-page-header>
      <template #actions>
        <p-button label="All Categories" rounded severity="secondary" @click="navigateTo('/admin/categories')">
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
        <div class="flex items-center gap-3">
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
            alt="Category image"
            class="w-16 h-16 object-cover rounded"
          >
          <span v-else class="w-16 h-16 rounded bg-surface-800 flex items-center justify-center text-muted-color text-xs">No image</span>
          <input type="file" accept="image/*" class="text-sm text-muted-color" @change="onImageFilePicked">
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
