import type {Database} from "#shared/types/database.types";
import type {Skill} from "#shared/types/Skill";
import type {Company} from "#shared/types/Company";

export type Project = Database['public']['Tables']['projects']['Row']
export type ProjectUpdate = Database['public']['Tables']['projects']['Update']
export type ProjectInsert = Database['public']['Tables']['projects']['Insert']

export type FeaturedProjectRow = Database['public']['Tables']['featured_projects']['Row']

export type ProjectWithSkills = Project & {
  project_skills: { skills: Pick<Skill, 'id' | 'name' | 'icon'> }[]
}

export type FeaturedProject = FeaturedProjectRow & {
  projects: Pick<Project, 'name' | 'description' | 'summary' | 'slug' | 'image_url' | 'year'> & {
    project_skills: { skills: Pick<Skill, 'id' | 'name' | 'icon'> }[]
  }
}

export type ProjectAdminListItem = Pick<Project, 'id' | 'name' | 'year'> & {
  companies: Pick<Company, 'name'> | null
  featured_projects: Pick<FeaturedProjectRow, 'id'> | null
}