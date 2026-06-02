import type {Database} from "#shared/types/database.types";
import type {Skill} from "#shared/types/Skill";
import type {Company} from "#shared/types/Company";

export type Project = Database['public']['Tables']['projects']['Row']
export type ProjectUpdate = Database['public']['Tables']['projects']['Update']
export type ProjectInsert = Database['public']['Tables']['projects']['Insert']

export type FeaturedProjectRow = Database['public']['Tables']['featured_projects']['Row']

export type ProjectWithSkills = Project & {
  companies: Pick<Company, 'name'> | null
  project_skills: { skills: Pick<Skill, 'id' | 'name' | 'icon'> }[]
}

export type FeaturedProject = FeaturedProjectRow & {
  projects: Pick<Project, 'id' | 'name' | 'description' | 'summary' | 'slug' | 'image_url' | 'year'> & {
    companies: Pick<Company, 'name'> | null
    project_skills: { skills: Pick<Skill, 'id' | 'name' | 'icon'> }[]
  }
}

export type ProjectCardItem = {
  id: string
  name: string
  year: number | null
  summary: string | null
  slug: string
  image_url: string | null
  companies: Pick<Company, 'name'> | null
  project_skills: { skills: Pick<Skill, 'id' | 'name' | 'icon'> }[]
  tagline: string | null
  featured: boolean
}

export type ProjectDetail = Pick<Project, 'id' | 'name' | 'slug' | 'description' | 'summary' | 'image_url' | 'year'> & {
  companies: Pick<Company, 'name'> | null
  project_skills: { skills: Pick<Skill, 'id' | 'name' | 'icon'> }[]
}

export type ProjectAdminListItem = Pick<Project, 'id' | 'name' | 'year'> & {
  companies: Pick<Company, 'name'> | null
  featured_projects: Pick<FeaturedProjectRow, 'id'> | null
}