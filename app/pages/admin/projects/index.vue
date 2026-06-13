<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Projects' })

import { FilterMatchMode } from '@primevue/core/api'
import type { ProjectAdminListItem } from '#shared/types/Project'

const supabase = useSupabaseClient()

const filters = ref({ global: { value: null as string | null, matchMode: FilterMatchMode.CONTAINS } })

const {
  data: projects,
  pending: projectsLoading,
  refresh: refreshProjects,
} = await useAsyncData<ProjectAdminListItem[]>('admin-projects', async () => {
  const { data, error } = await supabase
    .from('projects')
    .select('id, name, slug, year, companies(name), featured_projects(id)')
    .order('year', { ascending: false })

  if (error) throw error
  return data as ProjectAdminListItem[]
}, { lazy: true })

const { confirmDelete } = useAdminDelete('projects', 'Project', refreshProjects)
</script>

<template>
  <div class="flex flex-col gap-8 pb-8">
    <admin-page-header>
      <template #actions>
        <nuxt-link to="/admin/companies" class="text-sm text-muted-color hover:text-color underline">Manage Companies</nuxt-link>
        <p-button label="New Project" rounded severity="secondary" @click="navigateTo('/admin/projects/new')">
          <template #icon>
            <icon name="material-symbols:add-circle" class="text-lg" />
          </template>
        </p-button>
      </template>
    </admin-page-header>

    <p-progress-spinner v-if="projectsLoading" />

    <div v-else class="flex flex-col gap-4">
      <div class="flex justify-end">
        <p-input-text v-model="filters.global.value" placeholder="Search…" />
      </div>

      <p-data-table
        :value="projects ?? []"
        v-model:filters="filters"
        :global-filter-fields="['name']"
        :rows="20"
        paginator

        striped-rows
        empty-message="No projects found."
      >
        <p-column field="name" header="Name" :sortable="true">
          <template #body="{ data: row }">
            <nuxt-link
              :to="`/admin/projects/${row.id}`"
              class="hover:text-primary hover:underline cursor-pointer"
            >{{ row.name }}</nuxt-link>
          </template>
        </p-column>

        <p-column header="Company">
          <template #body="{ data: row }">
            {{ row.companies?.name ?? '—' }}
          </template>
        </p-column>

        <p-column field="year" header="Year" :sortable="true" />

        <p-column header="Featured">
          <template #body="{ data: row }">
            <p-tag
              v-if="row.featured_projects !== null"
              value="Featured"
              severity="success"
            />
            <span v-else>—</span>
          </template>
        </p-column>

        <p-column header="" style="width: 5rem">
          <template #body="{ data: row }">
            <div class="flex gap-1 justify-end">
              <nuxt-link
                :to="`/projects/${row.slug}`"
                target="_blank"
                rel="noopener noreferrer"
              >
                <p-button text severity="secondary" aria-label="View project">
                  <template #icon>
                    <icon name="material-symbols:visibility-outline" class="text-lg" />
                  </template>
                </p-button>
              </nuxt-link>
              <p-button
                text

                severity="danger"
                aria-label="Delete project"
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
