import { z } from 'zod'
import type { ContactMessageInsert } from '#shared/types/ContactMessage'

export const ContactMessageInsertSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters').max(100),
  email: z.string().email('Please enter a valid email address'),
  reason_id: z.string().min(1, 'Please select a reason for reaching out'),
  message: z.string().min(10, 'Message must be at least 10 characters').max(2000),
} satisfies { [K in keyof ContactMessageInsert]: z.ZodTypeAny })
