import { z } from 'zod'
import type { Credentials } from '~/types/Credentials'

export const CredentialsSchema = z.object({
  email: z.string().min(3).email(),
  password: z.string().min(8),
} satisfies { [K in keyof Credentials]: z.ZodTypeAny })
