import { z } from 'zod'

export const SkillInsertSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  proficiency: z.enum(['beginner', 'intermediate', 'advanced', 'expert']),
  category_id: z.string().nullable().optional(),
  icon: z.string().nullable().optional(),
  is_highlighted: z.boolean().optional(),
})
