import { expect, it } from 'vitest'
import { describeAuthenticated } from '../../helpers/auth'

describeAuthenticated('useSupabaseClient', () => {
    it('fetches from a known table without error', async () => {
        const supabase = useSupabaseClient()
        const { error } = await supabase.from('projects').select('id').limit(1)
        expect(error).toBeNull()
    })

    it('reflects authenticated user after sign-in', () => {
        const user = useSupabaseUser()
        expect(user.value).toBeTruthy()
        expect(user.value?.email).toBe(process.env.TEST_USER_EMAIL)
    })
})
