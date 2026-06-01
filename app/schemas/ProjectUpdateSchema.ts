import { z } from 'zod'

export const ProjectUpdateSchema = z.object({
  id: z.string(),
  name: z.string().min(1, 'Name is required').optional(),
  description: z.string().min(1, 'Description is required').optional(),
  company_id: z.string().nullable().optional(),
  year: z.number().int().min(1900).max(2100).optional(),
  skill_ids: z.array(z.string()).optional(),
})
