<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Contact Messages' })

import { FilterMatchMode } from '@primevue/core/api'
import type { ContactMessage } from '#shared/types/ContactMessage'

type ContactMessageWithReason = ContactMessage & {
  contact_reasons: { label: string } | null
}

const supabase = useSupabaseClient()

const viewingMessage = ref<ContactMessageWithReason | null>(null)
const viewDialogVisible = computed({
  get: () => viewingMessage.value !== null,
  set: (visible) => { if (!visible) viewingMessage.value = null },
})

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

const { confirmDelete } = useAdminDelete('contact_messages', 'Message', refreshMessages)
</script>

<template>
  <div class="flex flex-col gap-8 pb-8">
    <p-confirm-dialog />

    <p-dialog
      v-model:visible="viewDialogVisible"
      :header="viewingMessage ? `Message from ${viewingMessage.name}` : ''"
      modal
      :style="{ width: '36rem' }"
    >
      <div v-if="viewingMessage" class="flex flex-col gap-4">
        <div class="flex flex-col gap-1">
          <span class="text-xs font-semibold uppercase tracking-widest text-muted-color">From</span>
          <span>{{ viewingMessage.name }} — <a :href="`mailto:${viewingMessage.email}`" class="text-primary underline">{{ viewingMessage.email }}</a></span>
        </div>
        <div v-if="viewingMessage.contact_reasons" class="flex flex-col gap-1">
          <span class="text-xs font-semibold uppercase tracking-widest text-muted-color">Reason</span>
          <span>{{ viewingMessage.contact_reasons.label }}</span>
        </div>
        <div class="flex flex-col gap-1">
          <span class="text-xs font-semibold uppercase tracking-widest text-muted-color">Message</span>
          <p class="whitespace-pre-wrap leading-relaxed">{{ viewingMessage.message }}</p>
        </div>
        <div class="flex flex-col gap-1">
          <span class="text-xs font-semibold uppercase tracking-widest text-muted-color">Received</span>
          <span>{{ formatDate(viewingMessage.created_at) }}</span>
        </div>
      </div>
    </p-dialog>

    <admin-page-header />

    <p-progress-spinner v-if="messagesLoading" />

    <div v-else class="flex flex-col gap-4">
      <div class="flex justify-end">
        <p-input-text v-model="filters.global.value" placeholder="Search…" />
      </div>

      <p-data-table
        :value="messages ?? []"
        v-model:filters="filters"
        :global-filter-fields="['name', 'email', 'message']"
        :rows="20"
        paginator

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
            <span class="line-clamp-1 max-w-xs block text-muted-color">{{ row.message }}</span>
          </template>
        </p-column>

        <p-column header="Received" :sortable="true" field="created_at">
          <template #body="{ data: row }">
            {{ formatDate(row.created_at) }}
          </template>
        </p-column>

        <p-column header="" style="width: 6rem">
          <template #body="{ data: row }">
            <div class="flex gap-1 justify-end">
              <p-button
                text

                severity="secondary"
                aria-label="View message"
                @click="viewingMessage = row"
              >
                <template #icon>
                  <icon name="material-symbols:open-in-new" class="text-lg" />
                </template>
              </p-button>
              <p-button
                text

                severity="danger"
                aria-label="Delete message"
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
