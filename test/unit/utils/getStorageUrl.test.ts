import {describe, it, expect} from 'vitest'
import {createClient} from '@supabase/supabase-js'
import {getStorageUrl} from '../../../app/utils/getStorageUrl'

const supabaseClient = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_KEY!
)

describe('getStorageUrl', () => {
    it('returns a non-empty string for valid bucket and path inputs', () => {
        const result = getStorageUrl(supabaseClient, 'icons', 'logos/company.png')

        expect(typeof result).toBe('string')
        expect(result.length).toBeGreaterThan(0)
    })

    it('output string contains the path as a suffix', () => {
        const bucket = 'images'
        const path = 'projects/screenshot.webp'

        const result = getStorageUrl(supabaseClient, bucket, path)

        expect(result.endsWith(path)).toBe(true)
    })
})
