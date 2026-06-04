<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'New Skill' })

import { zodResolver } from '@primevue/forms/resolvers/zod'
import { SkillInsertSchema } from '~/schemas/SkillInsertSchema'
import type { SkillCategory } from '#shared/types/Skill'

const supabase = useSupabaseClient()
const toast = useToast()

const resolver = zodResolver(SkillInsertSchema)
const proficiencyOptions = ['beginner', 'intermediate', 'advanced', 'expert'] as const

const { data: categories } = await useAsyncData<SkillCategory[]>('skill-categories', async () => {
  const { data, error } = await supabase
    .from('skill_categories')
    .select('id, name, icon, order')
    .order('order', { ascending: true })
  if (error) throw error
  return data as SkillCategory[]
})

async function onSubmit({ valid, values }: { valid: boolean; values: Record<string, unknown> }) {
  if (!valid) return

  const { data, error } = await supabase
    .from('skills')
    .insert({
      name: values.name as string,
      proficiency: values.proficiency as 'beginner' | 'intermediate' | 'advanced' | 'expert',
      category_id: (values.category_id as string) || null,
      icon: (values.icon as string) || null,
      is_highlighted: (values.is_highlighted as boolean) ?? false,
    })
    .select('id')
    .single()

  if (error) {
    toast.add({ severity: 'error', summary: 'Create failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Skill created', life: 3000 })
  await navigateTo(`/admin/skills/${data.id}`)
}
</script>

<template>
  <div class="flex flex-col gap-8 max-w-2xl mx-auto px-6 pb-8">
    <admin-page-header>
      <template #actions>
        <p-button label="All Skills" rounded severity="secondary" @click="navigateTo('/admin/skills')">
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

      <p-form-field v-slot="$field" name="proficiency" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Proficiency</label>
        <p-select v-bind="$field" :options="proficiencyOptions" fluid class="capitalize" />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="category_id" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Category</label>
        <p-select
          v-bind="$field"
          :options="categories ?? []"
          option-label="name"
          option-value="id"
          filter
          show-clear
          fluid
          placeholder="None"
        />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="icon" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Icon</label>
        <p-input-text v-bind="$field" fluid placeholder="e.g. logos:vue" class="font-mono" />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="is_highlighted" class="flex flex-col gap-1">
        <div class="flex items-center gap-2">
          <p-checkbox v-bind="$field" binary :model-value="$field.value ?? false" input-id="is_highlighted" />
          <label for="is_highlighted" class="text-sm font-medium text-muted-color cursor-pointer">Highlighted</label>
        </div>
      </p-form-field>

      <div class="pt-2">
        <p-button type="submit" label="Create Skill" rounded severity="secondary">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </div>
    </p-form>
  </div>
</template>
