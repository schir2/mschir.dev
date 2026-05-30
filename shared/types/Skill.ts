import type {Database} from "#shared/types/database.types";

export type Skill = Database['public']['Tables']['skills']['Row']
export type SkillUpdate = Database['public']['Tables']['skills']['Update']
export type SkillInsert = Database['public']['Tables']['skills']['Insert']