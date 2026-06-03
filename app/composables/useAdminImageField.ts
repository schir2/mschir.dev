export function useAdminImageField(
  bucket: string,
  prefix: string,
  initialPath?: string | null,
) {
  const supabase = useSupabaseClient()
  const toast = useToast()

  const stagedFile = ref<File | null>(null)
  const previewUrl = ref<string | null>(
    initialPath
      ? supabase.storage.from(bucket).getPublicUrl(initialPath).data.publicUrl
      : null,
  )

  function onFilePicked(event: Event) {
    const input = event.target as HTMLInputElement
    const file = input.files?.[0] ?? null
    stagedFile.value = file
    if (file) previewUrl.value = URL.createObjectURL(file)
  }

  async function uploadAndGet(currentPath?: string | null): Promise<string | null> {
    if (!stagedFile.value) return currentPath ?? null
    try {
      const newPath = await useImageUpload(bucket, prefix, stagedFile.value, currentPath ?? undefined)
      return newPath
    }
    catch (error: unknown) {
      const message = error instanceof Error ? error.message : String(error)
      toast.add({ severity: 'error', summary: 'Image upload failed', detail: message, life: 4000 })
      throw error
    }
    finally {
      stagedFile.value = null
    }
  }

  return { previewUrl, onFilePicked, uploadAndGet }
}
