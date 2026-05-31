import type {SupabaseClient} from '@supabase/supabase-js'

export function getStorageUrl(client: SupabaseClient, bucket: string, path: string): string {
    return client.storage.from(bucket).getPublicUrl(path).data.publicUrl
}