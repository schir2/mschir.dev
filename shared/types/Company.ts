import type {Database} from "#shared/types/database.types";

export type Company = Database['public']['Tables']['companies']['Row']
export type CompanyUpdate = Database['public']['Tables']['companies']['Update']
export type CompanyInsert = Database['public']['Tables']['companies']['Insert']