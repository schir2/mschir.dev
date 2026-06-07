import { assertEquals } from 'https://deno.land/std@0.208.0/assert/mod.ts'
import { stub } from 'https://deno.land/std@0.208.0/testing/mock.ts'
import { handler } from '../send-contact-emails/index.ts'

const samplePayload = {
    name: 'Alice',
    email: 'alice@example.com',
    message: 'Hello there!',
    reasonLabel: 'Employer Inquiry',
}

function makeRequest(body: object): Request {
    return new Request('http://localhost/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
    })
}

Deno.test('send-contact-emails: happy path returns { ok: true }', async () => {
    const fetchStub = stub(
        globalThis,
        'fetch',
        () => Promise.resolve(new Response(JSON.stringify({ id: 'abc123' }), { status: 200 })),
    )

    try {
        const response = await handler(makeRequest(samplePayload))
        const body = await response.json()
        assertEquals(response.status, 200)
        assertEquals(body, { ok: true })
    } finally {
        fetchStub.restore()
    }
})

Deno.test('send-contact-emails: returns { ok: true } when Resend fails', async () => {
    const fetchStub = stub(
        globalThis,
        'fetch',
        () => Promise.reject(new Error('Resend unavailable')),
    )

    try {
        const response = await handler(makeRequest(samplePayload))
        const body = await response.json()
        assertEquals(response.status, 200)
        assertEquals(body, { ok: true })
    } finally {
        fetchStub.restore()
    }
})
