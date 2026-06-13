import { z } from 'zod'

export const ProjectInsertSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().nullable().optional(),
  company_id: z.string().nullable().optional(),
  year: z.number().int().min(1900).max(2100),
  repo_url: z.string().url().nullable().optional(),
  project_url: z.string().url().nullable().optional(),
  is_public: z.boolean().optional(),
  skill_ids: z.array(z.string()).optional(),
})
