import type {Database} from "#shared/types/database.types";

export type Skill = Database['public']['Tables']['skills']['Row']
export type SkillUpdate = Database['public']['Tables']['skills']['Update']
export type SkillInsert = Database['public']['Tables']['skills']['Insert']

export type SkillCategory = Database['public']['Tables']['skill_categories']['Row']

export type SkillWithCategory = Skill & {
  skill_categories: Pick<SkillCategory, 'id' | 'name'> | null
}