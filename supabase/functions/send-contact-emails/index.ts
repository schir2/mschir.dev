const RESEND_ENDPOINT = 'https://api.resend.com/emails'
const OWNER_EMAIL = 'schir2@gmail.com'
const FROM_ADDRESS = 'contact@mschir.dev'

function escape(str: string): string {
    return str
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
}

export async function handler(req: Request): Promise<Response> {
    const { name, email, message, reasonLabel } = await req.json()

    const resendApiKey = Deno.env.get('RESEND_API_KEY') ?? ''

    try {
        await fetch(RESEND_ENDPOINT, {
            method: 'POST',
            headers: {
                Authorization: `Bearer ${resendApiKey}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                from: FROM_ADDRESS,
                to: OWNER_EMAIL,
                reply_to: email,
                subject: `New contact from ${name}`,
                html: `
                    <p><strong>Reason:</strong> ${escape(reasonLabel)}</p>
                    <p><strong>From:</strong> ${escape(name)} &lt;${escape(email)}&gt;</p>
                    <p><strong>Message:</strong></p>
                    <p>${escape(message).replace(/\n/g, '<br>')}</p>
                `,
            }),
        })
    } catch {
        // best-effort
    }

    try {
        await fetch(RESEND_ENDPOINT, {
            method: 'POST',
            headers: {
                Authorization: `Bearer ${resendApiKey}`,
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                from: FROM_ADDRESS,
                to: email,
                subject: `Your message came through`,
                html: `
                    <p>Hi ${escape(name)},</p>
                    <p>Your message came through. I will get back to you as soon as I can. — Marek</p>
                    <hr>
                    <p>${escape(message).replace(/\n/g, '<br>')}</p>
                `,
            }),
        })
    } catch {
        // best-effort
    }

    return new Response(JSON.stringify({ ok: true }), {
        headers: { 'Content-Type': 'application/json' },
    })
}

if (import.meta.main) {
    Deno.serve(handler)
}
