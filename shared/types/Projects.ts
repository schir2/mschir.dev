import type {Database} from "#shared/types/database.types";

export type Project = Database['public']['Tables']['projects']['Row']
export type Skill = Database['public']['Tables']['skills']['Row']

export type ProjectWithSkills = Project & {
  project_skills: { skills: Pick<Skill, 'id' | 'name' | 'icon'> }[]
}