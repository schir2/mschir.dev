import {z} from 'zod'
import {UserProfile} from "../types/UserProfile";

export const userProfileSchema = z.object({
    id: z.string().uuid(),
    first_name: z.string().min(1),
    last_name: z.string().min(1),
    display_name: z.string().min(3),
    created_at: z.date(),
    updated_at: z.date(),
    created_by: z.string().uuid(),
    updated_by: z.string().uuid(),
    avatar_url: z.string().optional().nullable(),
    email: z.string().email(),
} satisfies { [K in keyof UserProfile]: z.ZodTypeAny })

export const UserProfileInsertSchema = userProfileSchema.omit({
    created_at: true,
    updated_at: true,
    created_by: true,
    updated_by: true,
})


export const UserProfileUpdateSchema = userProfileSchema.omit({
    created_at: true,
    updated_at: true,
    created_by: true,
    updated_by: true,
})

export type UserProfileInsertData = z.infer<typeof UserProfileInsertSchema>
export type UserProfileUpdateData = z.infer<typeof UserProfileUpdateSchema>