import { it, expect, afterEach, beforeAll } from 'vitest'
import { describeAuthenticated } from '#tests/helpers/auth'

const uploadedFiles: Array<{ bucket: string; path: string }> = []

afterEach(async () => {
    const client = useSupabaseClient()
    for (const { bucket, path } of uploadedFiles) {
        await client.storage.from(bucket).remove([path])
    }
    uploadedFiles.length = 0
})

// PNG magic bytes — ensures MIME sniffing agrees with the declared image/png type
const pngBytes = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])

describeAuthenticated('useImageUpload', () => {
    beforeAll(async () => {
        const client = useSupabaseClient()
        const { data: existingFiles } = await client.storage.from('images').list('test-uploads')
        if (existingFiles && existingFiles.length > 0) {
            const paths = existingFiles.map(entry => `test-uploads/${entry.name}`)
            await client.storage.from('images').remove(paths)
        }
    })

    it('uploads a file and returns a path matching {prefix}/{uuid}.{ext}', async () => {
        const file = new File([pngBytes], 'photo.png', { type: 'image/png' })
        const returnedPath = await useImageUpload('images', 'test-uploads', file)
        uploadedFiles.push({ bucket: 'images', path: returnedPath })
        expect(returnedPath).toMatch(/^test-uploads\/[0-9a-f-]{36}\.png$/)
    })

    it('overwrites the existing file in place and returns the same path', async () => {
        const original = new File([pngBytes], 'original.png', { type: 'image/png' })
        const existingPath = await useImageUpload('images', 'test-uploads', original)
        uploadedFiles.push({ bucket: 'images', path: existingPath })

        const replacement = new File([pngBytes], 'replacement.png', { type: 'image/png' })
        const returnedPath = await useImageUpload('images', 'test-uploads', replacement, existingPath)

        expect(returnedPath).toBe(existingPath)
    })

    it('does not delete the old file when the upload fails', async () => {
        const original = new File([pngBytes], 'original.png', { type: 'image/png' })
        const oldPath = await useImageUpload('images', 'test-uploads', original)
        uploadedFiles.push({ bucket: 'images', path: oldPath })

        const badFile = new File([pngBytes], 'fail.png', { type: 'image/png' })
        await expect(useImageUpload('nonexistent-bucket', 'test-uploads', badFile, oldPath)).rejects.toThrow()

        const client = useSupabaseClient()
        const { data } = await client.storage.from('images').list('test-uploads')
        const filenames = (data ?? []).map(entry => entry.name)
        expect(filenames).toContain(oldPath.split('/').pop())
    })
})
