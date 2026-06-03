import { z } from 'zod'

export const CompanyInsertSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  url: z.string().url('Must be a valid URL').or(z.literal('')).nullable().optional(),
})
