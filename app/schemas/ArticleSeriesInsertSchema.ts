import { z } from 'zod'

export const ArticleSeriesInsertSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  slug: z.string().min(1, 'Slug is required'),
  description: z.string().min(1, 'Description is required'),
  author: z.string().min(1, 'Author is required'),
  image_url: z.string().optional(),
})
