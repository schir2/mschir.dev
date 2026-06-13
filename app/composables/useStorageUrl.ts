export function useStorageUrl() {
  const supabase = useSupabaseClient()

  function resolveStorageUrl(path: string | null, bucket: string): string | null {
    if (!path) return null
    if (path.startsWith('http://') || path.startsWith('https://')) return path
    return supabase.storage.from(bucket).getPublicUrl(path).data.publicUrl
  }

  function resolveImageUrl(path: string | null): string | null {
    return resolveStorageUrl(path, 'images')
  }

  function resolveIconUrl(path: string | null): string | null {
    return resolveStorageUrl(path, 'icons')
  }

  return { resolveStorageUrl, resolveImageUrl, resolveIconUrl }
}