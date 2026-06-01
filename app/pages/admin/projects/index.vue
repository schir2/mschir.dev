<script lang="ts" setup>
import type { ProjectAdminListItem } from '#shared/types/Project'

const supabase = useSupabaseClient()
const confirm = useConfirm()
const toast = useToast()

const {
  data: projects,
  pending: projectsLoading,
  refresh: refreshProjects,
} = await useAsyncData<ProjectAdminListItem[]>('admin-projects', async () => {
  const { data, error } = await supabase
    .from('projects')
    .select('id, name, year, companies(name), featured_projects(id)')
    .order('year', { ascending: false })

  if (error) throw error
  return data as ProjectAdminListItem[]
}, { lazy: true })

function confirmDelete(event: MouseEvent, projectId: string) {
  confirm.require({
    target: event.currentTarget as HTMLElement,
    message: 'Delete this project? This cannot be undone.',
    icon: 'pi pi-exclamation-triangle',
    acceptClass: 'p-button-danger',
    accept: () => deleteProject(projectId),
  })
}

async function deleteProject(projectId: string) {
  const { error } = await supabase
    .from('projects')
    .delete()
    .eq('id', projectId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Project deleted', life: 3000 })
  await refreshProjects()
}
</script>

<template>
  <div class="p-6">
    <p-confirm-popup />

    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold">Projects</h1>
      <div class="flex items-center gap-4">
        <nuxt-link to="/admin/companies" class="text-sm underline">Manage Companies</nuxt-link>
        <p-button
          label="New Project"
          icon="pi pi-plus"
          @click="$router.push('/admin/projects/new')"
        />
      </div>
    </div>

    <p-progress-spinner v-if="projectsLoading" />

    <p-data-table
      v-else
      :value="projects ?? []"
      :rows="20"
      paginator
      empty-message="No projects found."
    >
      <p-column field="name" header="Name" />

      <p-column header="Company">
        <template #body="{ data: row }">
          {{ row.companies?.name ?? '—' }}
        </template>
      </p-column>

      <p-column field="year" header="Year" />

      <p-column header="Featured">
        <template #body="{ data: row }">
          <p-tag
            v-if="row.featured_projects.length > 0"
            value="Featured"
            severity="success"
          />
          <span v-else>—</span>
        </template>
      </p-column>

      <p-column header="Actions">
        <template #body="{ data: row }">
          <div class="flex gap-2">
            <p-button
              icon="pi pi-pencil"
              size="small"
              text
              @click="$router.push(`/admin/projects/${row.id}`)"
            />
            <p-button
              icon="pi pi-trash"
              size="small"
              text
              severity="danger"
              @click="confirmDelete($event, row.id)"
            />
          </div>
        </template>
      </p-column>
    </p-data-table>
  </div>
</template>
