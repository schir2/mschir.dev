import { z } from 'zod'

export const ArticleCategoryUpdateSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  slug: z.string().min(1, 'Slug is required'),
  color: z.string().nullable().optional(),
  description: z.string().nullable().optional(),
  image_url: z.string().nullable().optional(),
})
