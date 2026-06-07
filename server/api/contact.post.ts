import { serverSupabaseServiceRole } from '#supabase/server'

export default defineEventHandler(async (event) => {
    const { name, email, reason_id, message, turnstileToken } = await readBody(event)

    await verifyTurnstileToken(turnstileToken)

    const supabase = serverSupabaseServiceRole(event)
    const { error } = await supabase
        .from('contact_messages')
        .insert({ name, email, reason_id, message })

    if (error) {
        throw createError({ statusCode: 500, statusMessage: 'Failed to save message' })
    }

    let reasonLabel = ''
    if (reason_id) {
        const { data: reason } = await supabase
            .from('contact_reasons')
            .select('label')
            .eq('id', reason_id)
            .single()
        reasonLabel = reason?.label ?? ''
    }

    // Fire-and-forget — email failure must never surface to the user
    supabase.functions.invoke('send-contact-emails', {
        body: { name, email, message, reasonLabel },
    })

    return { success: true }
})
