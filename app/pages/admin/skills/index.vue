<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Skills' })

import { FilterMatchMode } from '@primevue/core/api'
import type { SkillWithCategory } from '#shared/types/Skill'

const supabase = useSupabaseClient()

const filters = ref({ global: { value: null as string | null, matchMode: FilterMatchMode.CONTAINS } })

const {
  data: skills,
  pending: skillsLoading,
  refresh: refreshSkills,
} = await useAsyncData<SkillWithCategory[]>('admin-skills', async () => {
  const { data, error } = await supabase
    .from('skills')
    .select('id, name, proficiency, category_id, icon, is_highlighted, skill_categories(id, name)')
    .order('name', { ascending: true })
  if (error) throw error
  return data as SkillWithCategory[]
}, { lazy: true })

const { confirmDelete } = useAdminDelete('skills', 'Skill', refreshSkills)
</script>

<template>
  <div class="flex flex-col gap-8 pb-8">
    <p-confirm-dialog />

    <admin-page-header>
      <template #actions>
        <p-button label="New Skill" rounded severity="secondary" @click="navigateTo('/admin/skills/new')">
          <template #icon>
            <icon name="material-symbols:add-circle" class="text-lg" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-progress-spinner v-if="skillsLoading" />

    <div v-else class="flex flex-col gap-4">
      <div class="flex justify-end">
        <p-input-text v-model="filters.global.value" placeholder="Search…" />
      </div>

      <p-data-table
        :value="skills ?? []"
        v-model:filters="filters"
        :global-filter-fields="['name', 'proficiency', 'icon']"
        :rows="20"
        paginator

        striped-rows
        empty-message="No skills found."
      >
        <p-column field="name" header="Name" :sortable="true">
          <template #body="{ data: row }">
            <nuxt-link
              :to="`/admin/skills/${row.id}`"
              class="hover:text-primary hover:underline cursor-pointer"
            >{{ row.name }}</nuxt-link>
          </template>
        </p-column>

        <p-column field="proficiency" header="Proficiency" :sortable="true">
          <template #body="{ data: row }">
            <span class="capitalize">{{ row.proficiency }}</span>
          </template>
        </p-column>

        <p-column header="Category" :sortable="false">
          <template #body="{ data: row }">
            <span v-if="row.skill_categories">{{ row.skill_categories.name }}</span>
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column field="icon" header="Icon">
          <template #body="{ data: row }">
            <div v-if="row.icon" class="flex items-center gap-2">
              <icon :name="row.icon" class="text-lg" />
              <span class="text-muted-color font-mono text-xs">{{ row.icon }}</span>
            </div>
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column header="Highlighted" style="width: 7rem">
          <template #body="{ data: row }">
            <icon
              v-if="row.is_highlighted"
              name="material-symbols:star"
              class="text-primary text-lg"
            />
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column header="" style="width: 4rem">
          <template #body="{ data: row }">
            <div class="flex gap-1 justify-end">
              <p-button
                text

                severity="danger"
                aria-label="Delete skill"
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
    </div>
  </div>
</template>
