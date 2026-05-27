import { serverSupabaseServiceRole } from '#supabase/server'

export default defineEventHandler(async (event) => {
    const { name, email, reason_id, message, turnstileToken } = await readBody(event)
    const config = useRuntimeConfig()

    // Verify Turnstile token before touching the DB
    const params = new URLSearchParams()
    params.append('secret', config.turnstileSecretKey)
    params.append('response', turnstileToken)

    const verification = await $fetch<{ success: boolean }>(
        'https://challenges.cloudflare.com/turnstile/v0/siteverify',
        {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString(),
        }
    )

    if (!verification.success) {
        throw createError({ statusCode: 400, statusMessage: 'CAPTCHA verification failed' })
    }

    const supabase = serverSupabaseServiceRole(event)
    const { error } = await supabase
        .from('contact_messages')
        .insert({ name, email, reason_id, message })

    if (error) {
        throw createError({ statusCode: 500, statusMessage: 'Failed to save message' })
    }

    // Email notification — best-effort; failure does not fail the request
    try {
        await $fetch('https://api.resend.com/emails', {
            method: 'POST',
            headers: {
                Authorization: `Bearer ${config.resendApiKey}`,
                'Content-Type': 'application/json',
            },
            body: {
                from: 'contact@mschir.dev',
                to: 'schir2@gmail.com',
                subject: `New contact from ${name}`,
                html: `
                    <p><strong>From:</strong> ${escape(name)} &lt;${escape(email)}&gt;</p>
                    <p><strong>Message:</strong></p>
                    <p>${escape(message).replace(/\n/g, '<br>')}</p>
                `,
            },
        })
    } catch {
        // swallowed intentionally
    }

    return { success: true }
})

function escape(str: string): string {
    return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
}