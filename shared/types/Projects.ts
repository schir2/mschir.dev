import type {Database} from "#shared/types/database.types";
import type {Skill} from "#shared/types/Skill";

export type Project = Database['public']['Tables']['projects']['Row']
export type ProjectUpdate = Database['public']['Tables']['projects']['Update']
export type ProjectInsert = Database['public']['Tables']['projects']['Insert']

export type ProjectWithSkills = Project & {
  project_skills: { skills: Pick<Skill, 'id' | 'name' | 'icon'> }[]
}