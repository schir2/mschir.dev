import { describe, it, expect } from 'vitest'
import { mockNuxtImport } from '@nuxt/test-utils/runtime'

mockNuxtImport('useSupabaseClient', () => () => ({
  storage: {
    from: (bucket: string) => ({
      getPublicUrl: (path: string) => ({ data: { publicUrl: `https://storage.test/${bucket}/${path}` } }),
    }),
  },
}))

describe('useStorageUrl', () => {
  describe('resolveImageUrl', () => {
    it('returns null when path is null', () => {
      const { resolveImageUrl } = useStorageUrl()
      expect(resolveImageUrl(null)).toBeNull()
    })

    it('returns the URL unchanged when path is an absolute http URL', () => {
      const { resolveImageUrl } = useStorageUrl()
      const url = 'https://example.com/image.jpg'
      expect(resolveImageUrl(url)).toBe(url)
    })

    it('returns the URL unchanged when path is an absolute https URL', () => {
      const { resolveImageUrl } = useStorageUrl()
      const url = 'https://cdn.example.com/image.jpg'
      expect(resolveImageUrl(url)).toBe(url)
    })

    it('resolves a storage path to a full public URL containing the original path', () => {
      const { resolveImageUrl } = useStorageUrl()
      const result = resolveImageUrl('article-heroes/abc123.jpg')
      expect(result).not.toBeNull()
      expect(result!.startsWith('http')).toBe(true)
      expect(result).toContain('article-heroes/abc123.jpg')
    })
  })

  describe('resolveIconUrl', () => {
    it('returns null when path is null', () => {
      const { resolveIconUrl } = useStorageUrl()
      expect(resolveIconUrl(null)).toBeNull()
    })

    it('resolves a storage path to a URL containing the icons bucket and the original path', () => {
      const { resolveIconUrl } = useStorageUrl()
      const result = resolveIconUrl('company-logos/test.svg')
      expect(result).not.toBeNull()
      expect(result).toContain('icons')
      expect(result).toContain('company-logos/test.svg')
    })
  })

  describe('resolveStorageUrl', () => {
    it('returns null when path is null', () => {
      const { resolveStorageUrl } = useStorageUrl()
      expect(resolveStorageUrl(null, 'images')).toBeNull()
    })

    it('resolves a storage path to a URL containing the original path', () => {
      const { resolveStorageUrl } = useStorageUrl()
      const result = resolveStorageUrl('some/path.jpg', 'images')
      expect(result).not.toBeNull()
      expect(result).toContain('some/path.jpg')
    })
  })
})
