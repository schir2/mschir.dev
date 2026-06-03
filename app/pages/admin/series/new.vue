<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'New Series' })

import { zodResolver } from '@primevue/forms/resolvers/zod'
import { ArticleSeriesInsertSchema } from '~/schemas/ArticleSeriesInsertSchema'

const supabase = useSupabaseClient()
const toast = useToast()
const { previewUrl: imagePreviewUrl, onFilePicked: onImageFilePicked, uploadAndGet } = useAdminImageField('images', 'series-images')

const resolver = zodResolver(ArticleSeriesInsertSchema)

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
    .from('article_series')
    .insert({
      title: values.title as string,
      slug: values.slug as string,
      description: (values.description as string) || '',
      author: (values.author as string) || '',
      image_url: imagePath,
    })
    .select('id')
    .single()

  if (error) {
    toast.add({ severity: 'error', summary: 'Create failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Series created', life: 3000 })
  await navigateTo(`/admin/series/${data.id}`)
}
</script>

<template>
  <div class="max-w-2xl mx-auto px-6 pt-6 pb-8">
    <admin-page-header>
      <template #actions>
        <p-button label="All Series" rounded severity="secondary" @click="navigateTo('/admin/series')">
          <template #icon>
            <icon name="material-symbols:arrow-back" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-form :resolver="resolver" class="flex flex-col gap-5" @submit="onSubmit">
      <p-form-field v-slot="$field" name="title" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Title</label>
        <p-input-text v-bind="$field" fluid />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="slug" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Slug</label>
        <p-input-text v-bind="$field" fluid class="font-mono" />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="description" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Description</label>
        <p-textarea v-bind="$field" fluid rows="3" auto-resize placeholder="What is this series about…" />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="author" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Author</label>
        <p-input-text v-bind="$field" fluid />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <div class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Cover Image</label>
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
        <p-button type="submit" label="Create Series" rounded severity="secondary">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </div>
    </p-form>
  </div>
</template>
