<script lang="ts" setup>
definePageMeta({ layout: 'admin-detail', title: 'Edit Skill' })

import { zodResolver } from '@primevue/forms/resolvers/zod'
import { SkillUpdateSchema } from '~/schemas/SkillUpdateSchema'
import type { Skill, SkillCategory } from '#shared/types/Skill'

const route = useRoute()
const supabase = useSupabaseClient()
const toast = useToast()
const confirm = useConfirm()

const skillId = route.params.id as string

const proficiencyOptions = ['beginner', 'intermediate', 'advanced', 'expert'] as const

const { data: skill, refresh } = await useAsyncData<Skill>(`skill-${skillId}`, async () => {
  const { data, error } = await supabase
    .from('skills')
    .select('id, name, proficiency, category_id, icon, is_highlighted')
    .eq('id', skillId)
    .single()
  if (error) throw error
  return data as Skill
})

const { data: categories } = await useAsyncData<SkillCategory[]>('skill-categories', async () => {
  const { data, error } = await supabase
    .from('skill_categories')
    .select('id, name, icon, order')
    .order('order', { ascending: true })
  if (error) throw error
  return data as SkillCategory[]
})

if (!skill.value) {
  throw createError({ statusCode: 404, statusMessage: 'Skill not found' })
}

const initialValues = {
  name: skill.value.name,
  proficiency: skill.value.proficiency,
  category_id: skill.value.category_id ?? null,
  icon: skill.value.icon ?? '',
  is_highlighted: skill.value.is_highlighted,
}

const resolver = zodResolver(SkillUpdateSchema)

async function onSubmit({ valid, values }: { valid: boolean; values: Record<string, unknown> }) {
  if (!valid) return

  const { error } = await supabase
    .from('skills')
    .update({
      name: values.name as string,
      proficiency: values.proficiency as 'beginner' | 'intermediate' | 'advanced' | 'expert',
      category_id: (values.category_id as string) || null,
      icon: (values.icon as string) || null,
      is_highlighted: (values.is_highlighted as boolean) ?? false,
    })
    .eq('id', skillId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Save failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Skill saved', life: 3000 })
  await refresh()
}

function confirmDelete() {
  confirm.require({
    header: 'Delete Skill',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: async () => {
      const { error } = await supabase.from('skills').delete().eq('id', skillId)
      if (error) {
        toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
        return
      }
      await navigateTo('/admin/skills')
    },
  })
}
</script>

<template>
  <div class="max-w-2xl mx-auto px-6 pt-6 pb-8">
    <p-confirm-dialog />

    <admin-page-header>
      <template #actions>
        <p-button label="All Skills" rounded severity="secondary" @click="navigateTo('/admin/skills')">
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

      <p-form-field v-slot="$field" name="proficiency" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Proficiency</label>
        <p-select
          v-bind="$field"
          :options="proficiencyOptions"
          fluid
          class="capitalize"
        />
        <small v-if="$field.invalid" class="text-red-400">{{ $field.error?.message }}</small>
      </p-form-field>

      <p-form-field v-slot="$field" name="category_id" class="flex flex-col gap-1">
        <label class="text-sm font-medium text-muted-color">Category</label>
        <p-select
          v-bind="$field"
          :options="categories ?? []"
          option-label="name"
          option-value="id"
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
          <p-checkbox v-bind="$field" binary :model-value="$field.value ?? false" input-id="is_highlighted_edit" />
          <label for="is_highlighted_edit" class="text-sm font-medium text-muted-color cursor-pointer">Highlighted</label>
        </div>
      </p-form-field>

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
