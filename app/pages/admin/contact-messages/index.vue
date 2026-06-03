<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Contact Messages' })

import { FilterMatchMode } from '@primevue/core/api'
import type { ContactMessage } from '#shared/types/ContactMessage'

type ContactMessageWithReason = ContactMessage & {
  contact_reasons: { label: string } | null
}

const supabase = useSupabaseClient()
const confirm = useConfirm()
const toast = useToast()

const filters = ref({ global: { value: null as string | null, matchMode: FilterMatchMode.CONTAINS } })

const {
  data: messages,
  pending: messagesLoading,
  refresh: refreshMessages,
} = await useAsyncData<ContactMessageWithReason[]>('admin-contact-messages', async () => {
  const { data, error } = await supabase
    .from('contact_messages')
    .select('id, name, email, message, created_at, contact_reasons(label)')
    .order('created_at', { ascending: false })
  if (error) throw error
  return data as ContactMessageWithReason[]
}, { lazy: true })

function formatDate(dateString: string): string {
  return new Date(dateString).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })
}

function confirmDelete(messageId: string) {
  confirm.require({
    header: 'Delete Message',
    message: 'This cannot be undone.',
    icon: 'material-symbols:warning-outline',
    rejectLabel: 'Cancel',
    acceptLabel: 'Delete',
    acceptClass: 'p-button-danger',
    accept: () => deleteMessage(messageId),
  })
}

async function deleteMessage(messageId: string) {
  const { error } = await supabase
    .from('contact_messages')
    .delete()
    .eq('id', messageId)

  if (error) {
    toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
    return
  }

  toast.add({ severity: 'success', summary: 'Message deleted', life: 3000 })
  await refreshMessages()
}
</script>

<template>
  <div class="pb-8">
    <p-confirm-dialog />

    <admin-page-header />

    <p-progress-spinner v-if="messagesLoading" />

    <template v-else>
      <div class="flex justify-end mb-3">
        <p-input-text v-model="filters.global.value" placeholder="Search…" size="small" />
      </div>

      <p-data-table
        :value="messages ?? []"
        v-model:filters="filters"
        :global-filter-fields="['name', 'email', 'message']"
        :rows="20"
        paginator
        size="small"
        striped-rows
        empty-message="No contact messages found."
      >
        <p-column field="name" header="Name" :sortable="true" />

        <p-column field="email" header="Email" :sortable="true">
          <template #body="{ data: row }">
            <a :href="`mailto:${row.email}`" class="text-primary underline">{{ row.email }}</a>
          </template>
        </p-column>

        <p-column header="Reason">
          <template #body="{ data: row }">
            <span v-if="row.contact_reasons">{{ row.contact_reasons.label }}</span>
            <span v-else class="text-muted-color">—</span>
          </template>
        </p-column>

        <p-column field="message" header="Message">
          <template #body="{ data: row }">
            <p-tooltip :value="row.message">
              <span class="line-clamp-1 cursor-default max-w-xs block">{{ row.message }}</span>
            </p-tooltip>
          </template>
        </p-column>

        <p-column header="Received" :sortable="true" field="created_at">
          <template #body="{ data: row }">
            {{ formatDate(row.created_at) }}
          </template>
        </p-column>

        <p-column header="" style="width: 4rem">
          <template #body="{ data: row }">
            <div class="flex gap-1 justify-end">
              <p-button
                text
                size="small"
                severity="danger"
                aria-label="Delete message"
                @click="confirmDelete(row.id)"
              >
                <template #icon>
                  <icon name="material-symbols:delete-outline" />
                </template>
              </p-button>
            </div>
          </template>
        </p-column>
      </p-data-table>
    </template>
  </div>
</template>
