import type { Database } from '#shared/types/database.types'

type TableName = keyof Database['public']['Tables']

export function useAdminDelete(
  table: TableName,
  entityLabel: string,
  refresh: () => Promise<void>,
  options?: { onDeleted?: (id: string) => Promise<void> },
) {
  const supabase = useSupabaseClient()
  const confirm = useConfirm()
  const toast = useToast()

  function confirmDelete(id: string) {
    confirm.require({
      header: `Delete ${entityLabel}`,
      message: 'This cannot be undone.',
      icon: 'material-symbols:warning-outline',
      rejectLabel: 'Cancel',
      acceptLabel: 'Delete',
      acceptProps: { severity: 'danger' },
      rejectProps: { severity: 'secondary', outlined: true },
      accept: () => deleteRecord(id),
    })
  }

  async function deleteRecord(id: string) {
    const { error } = await (supabase as ReturnType<typeof useSupabaseClient>).from(table as string).delete().eq('id', id)
    if (error) {
      toast.add({ severity: 'error', summary: 'Delete failed', detail: error.message, life: 4000 })
      return
    }
    await options?.onDeleted?.(id)
    toast.add({ severity: 'success', summary: `${entityLabel} deleted`, life: 3000 })
    await refresh()
  }

  return { confirmDelete }
}
