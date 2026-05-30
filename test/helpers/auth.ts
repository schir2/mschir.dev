import { afterAll, beforeAll, describe } from 'vitest'

export async function signIn(): Promise<void> {
    const supabase = useSupabaseClient()
    const { error } = await supabase.auth.signInWithPassword({
        email: process.env.TEST_USER_EMAIL!,
        password: process.env.TEST_USER_PASSWORD!,
    })
    if (error) throw new Error(`Test sign-in failed: ${error.message}`)
}

export async function signOut(): Promise<void> {
    const supabase = useSupabaseClient()
    await supabase.auth.signOut()
}

export function describeAuthenticated(label: string, fn: () => void): void {
    describe(label, () => {
        beforeAll(signIn)
        afterAll(signOut)
        fn()
    })
}
