import type {Database} from "#shared/types/database.types";


export type ContactMessage = Database['public']['Tables']['contact_messages']['Row']
export type ContactMessageUpdate = Database['public']['Tables']['contact_messages']['Update']
export type ContactMessageInsert = Database['public']['Tables']['contact_messages']['Insert']
