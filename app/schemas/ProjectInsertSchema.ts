import { z } from 'zod'

export const ProjectInsertSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().min(1, 'Description is required'),
  company_id: z.string().nullable().optional(),
  year: z.number().int().min(1900).max(2100),
  skill_ids: z.array(z.string()).optional(),
})
