import type {Database} from "#shared/types/database.types";

export type ContactReason = Database['public']['Tables']['contact_reasons']['Row']
export type ContactReasonUpdate = Database['public']['Tables']['contact_reasons']['Update']
export type ContactReasonInsert = Database['public']['Tables']['contact_reasons']['Insert']