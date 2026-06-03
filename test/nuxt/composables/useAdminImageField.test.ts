import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { mockNuxtImport } from '@nuxt/test-utils/runtime'

const { mockUpload, mockToastAdd } = vi.hoisted(() => ({
  mockUpload: vi.fn(),
  mockToastAdd: vi.fn(),
}))

mockNuxtImport('useImageUpload', () => mockUpload)
mockNuxtImport('useToast', () => () => ({ add: mockToastAdd }))
mockNuxtImport('useSupabaseClient', () => () => ({
  storage: {
    from: () => ({
      getPublicUrl: (path: string) => ({ data: { publicUrl: `https://storage.test/${path}` } }),
    }),
  },
}))

function makeFilePickEvent(file: File): Event {
  const input = document.createElement('input')
  Object.defineProperty(input, 'files', { value: { 0: file, length: 1 } })
  return { target: input } as unknown as Event
}

beforeEach(() => {
  mockUpload.mockReset()
  mockToastAdd.mockClear()
  global.URL.createObjectURL = vi.fn().mockReturnValue('blob:fake-preview')
})

afterEach(() => {
  vi.restoreAllMocks()
})

describe('useAdminImageField', () => {
  it('previewUrl is null when no initial path is provided', () => {
    const { previewUrl } = useAdminImageField('images', 'category-images')
    expect(previewUrl.value).toBeNull()
  })

  it('previewUrl is the public URL of the initial path when one is provided', () => {
    const { previewUrl } = useAdminImageField('images', 'category-images', 'category-images/abc.jpg')
    expect(previewUrl.value).toBe('https://storage.test/category-images/abc.jpg')
  })

  it('onFilePicked sets previewUrl to a blob URL when a file is selected', () => {
    const { previewUrl, onFilePicked } = useAdminImageField('images', 'category-images')
    const file = new File(['content'], 'photo.png', { type: 'image/png' })
    onFilePicked(makeFilePickEvent(file))
    expect(previewUrl.value).toBe('blob:fake-preview')
  })

  it('uploadAndGet returns currentPath without calling upload when no file is staged', async () => {
    const { uploadAndGet } = useAdminImageField('images', 'category-images')
    const result = await uploadAndGet('existing/path.jpg')
    expect(result).toBe('existing/path.jpg')
    expect(mockUpload).not.toHaveBeenCalled()
  })

  it('uploadAndGet returns null when no file is staged and currentPath is null', async () => {
    const { uploadAndGet } = useAdminImageField('images', 'category-images')
    expect(await uploadAndGet(null)).toBeNull()
    expect(await uploadAndGet()).toBeNull()
  })

  it('uploadAndGet calls upload with correct args and returns the new path', async () => {
    mockUpload.mockResolvedValue('category-images/new-uuid.png')
    const { onFilePicked, uploadAndGet } = useAdminImageField('images', 'category-images')
    const file = new File(['content'], 'photo.png', { type: 'image/png' })
    onFilePicked(makeFilePickEvent(file))

    const result = await uploadAndGet('old/path.jpg')
    expect(mockUpload).toHaveBeenCalledWith('images', 'category-images', file, 'old/path.jpg')
    expect(result).toBe('category-images/new-uuid.png')
  })

  it('uploadAndGet clears the staged file after a successful upload', async () => {
    mockUpload.mockResolvedValue('category-images/new-uuid.png')
    const { onFilePicked, uploadAndGet } = useAdminImageField('images', 'category-images')
    const file = new File(['content'], 'photo.png', { type: 'image/png' })
    onFilePicked(makeFilePickEvent(file))

    await uploadAndGet(null)
    mockUpload.mockClear()
    await uploadAndGet(null)
    expect(mockUpload).not.toHaveBeenCalled()
  })

  it('uploadAndGet clears the staged file and re-throws when upload fails', async () => {
    mockUpload.mockRejectedValue(new Error('Storage quota exceeded'))
    const { onFilePicked, uploadAndGet } = useAdminImageField('images', 'category-images')
    const file = new File(['content'], 'photo.png', { type: 'image/png' })
    onFilePicked(makeFilePickEvent(file))

    await expect(uploadAndGet(null)).rejects.toThrow('Storage quota exceeded')

    mockUpload.mockClear()
    const result = await uploadAndGet('fallback/path.jpg')
    expect(mockUpload).not.toHaveBeenCalled()
    expect(result).toBe('fallback/path.jpg')
  })

  it('uploadAndGet toasts an error message when upload fails', async () => {
    mockUpload.mockRejectedValue(new Error('Network error'))
    const { onFilePicked, uploadAndGet } = useAdminImageField('images', 'category-images')
    const file = new File(['content'], 'photo.png', { type: 'image/png' })
    onFilePicked(makeFilePickEvent(file))

    await expect(uploadAndGet(null)).rejects.toThrow()
    expect(mockToastAdd).toHaveBeenCalledWith(
      expect.objectContaining({ severity: 'error', summary: 'Image upload failed' }),
    )
  })
})
