<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'Edit Series' })

import { zodResolver } from '@primevue/forms/resolvers/zod'
import { ArticleSeriesUpdateSchema } from '~/schemas/ArticleSeriesUpdateSchema'
import type { ArticleSeries } from '#shared/types/ArticleSeries'

const route = useRoute()
const supabase = useSupabaseClient()
const toast = useToast()
const confirm = useConfirm()

const seriesId = route.params.id as string

const { data: series, refresh } = await useAsyncData<ArticleSeries>(`series-${seriesId}`, async () => {
  const { data, error } = await supabase
    .from('article_series')
    .select('id, title, slug, description, author, image_url, created_at, updated_at')
    .eq('id', seriesId)
    .single()
  if (error) throw error
  return data as ArticleSeries
})

if (!series.value) {
  throw createError({ statusCode: 404, statusMessage: 'Series not found' })
}

const initialValues = {
  title: series.value.title,
  slug: series.value.slug,
  description: series.value.description ?? '',
  author: series.value.author ?? '',
}

const { previewUrl: imagePreviewUrl, onFilePicked: onImageFilePicked, uploadAndGet } = useAdminImageField('images', 'series-images', series.value.image_url)

const resolver = zodResolver(ArticleSeriesUpdateSchema)

async function onSubmit({ valid, values }: { valid: boolean; values: Record<string, unknown> }) {
  if (!valid) return

  let newImagePath: string | null
  try {
    newImagePath = await uploadAndGet(series.value?.image_url ?? null)
  }
  catch {
    return
  }

  const { error } = await supabase
    .from('article_series')
    .update({
      title: values.title as string,
      slug: values.slug as string,
      description: (values.description as string) || '',
      author: (values.author as string) || '',
      image_url: newImagePath,
    })
    .eq('id', seriesId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Save failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Series saved', life: 3000 })
  await refresh()
}

function confirmDelete() {
  confirm.require({
    header: 'Delete Series',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptProps: { severity: 'danger' },
    rejectProps: { severity: 'secondary', outlined: true },
    accept: async () => {
      const { error } = await supabase.from('article_series').delete().eq('id', seriesId)
      if (error) {
        toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
        return
      }
      await navigateTo('/admin/series')
    },
  })
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

    <p-form :resolver="resolver" :initial-values="initialValues" class="flex flex-col gap-5" @submit="onSubmit">
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
            alt="Series cover"
            class="w-16 h-16 object-cover rounded"
          >
          <span v-else class="w-16 h-16 rounded bg-surface-800 flex items-center justify-center text-muted-color text-xs">No image</span>
          <input type="file" accept="image/*" class="text-sm text-muted-color" @change="onImageFilePicked">
        </div>
      </div>

      <div class="flex justify-between pt-2">
        <p-button type="submit" label="Save" rounded severity="success">
          <template #icon>
            <icon name="material-symbols:save" class="text-lg" />
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
