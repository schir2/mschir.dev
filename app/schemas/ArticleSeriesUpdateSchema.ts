import { z } from 'zod'

export const ArticleSeriesUpdateSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  slug: z.string().min(1, 'Slug is required'),
  description: z.string().nullable().optional(),
  author: z.string().nullable().optional(),
  image_url: z.string().nullable().optional(),
})
