import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mockNuxtImport } from '@nuxt/test-utils/runtime'

const { mockConfirmRequire, mockToastAdd, mockDeleteEq } = vi.hoisted(() => ({
  mockConfirmRequire: vi.fn(),
  mockToastAdd: vi.fn(),
  mockDeleteEq: vi.fn().mockResolvedValue({ error: null }),
}))

mockNuxtImport('useSupabaseClient', () => () => ({
  from: (_table: string) => ({
    delete: () => ({
      eq: mockDeleteEq,
    }),
  }),
}))

mockNuxtImport('useConfirm', () => () => ({ require: mockConfirmRequire }))
mockNuxtImport('useToast', () => () => ({ add: mockToastAdd }))

beforeEach(() => {
  mockConfirmRequire.mockClear()
  mockToastAdd.mockClear()
  mockDeleteEq.mockClear()
  mockDeleteEq.mockResolvedValue({ error: null })
})

describe('useAdminDelete', () => {
  it('confirmDelete calls confirm.require with the correct header', () => {
    const refresh = vi.fn().mockResolvedValue(undefined)
    const { confirmDelete } = useAdminDelete('articles', 'Article', refresh)

    confirmDelete('abc-123')

    expect(mockConfirmRequire).toHaveBeenCalledOnce()
    expect(mockConfirmRequire).toHaveBeenCalledWith(
      expect.objectContaining({ header: 'Delete Article' }),
    )
  })

  it('confirmDelete calls confirm.require with the correct message', () => {
    const refresh = vi.fn().mockResolvedValue(undefined)
    const { confirmDelete } = useAdminDelete('articles', 'Article', refresh)

    confirmDelete('abc-123')

    expect(mockConfirmRequire).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'This cannot be undone.' }),
    )
  })

  it('confirmDelete passes correct acceptProps and rejectProps', () => {
    const refresh = vi.fn().mockResolvedValue(undefined)
    const { confirmDelete } = useAdminDelete('articles', 'Article', refresh)

    confirmDelete('abc-123')

    expect(mockConfirmRequire).toHaveBeenCalledWith(
      expect.objectContaining({
        acceptProps: { severity: 'danger' },
        rejectProps: { severity: 'secondary', outlined: true },
      }),
    )
  })

  it('when accept fires and delete succeeds: toasts success and calls refresh', async () => {
    const refresh = vi.fn().mockResolvedValue(undefined)
    const { confirmDelete } = useAdminDelete('articles', 'Article', refresh)

    confirmDelete('abc-123')

    const { accept } = mockConfirmRequire.mock.calls[0][0] as { accept: () => Promise<void> }
    await accept()

    expect(mockToastAdd).toHaveBeenCalledWith(
      expect.objectContaining({ severity: 'success', summary: 'Article deleted' }),
    )
    expect(refresh).toHaveBeenCalledOnce()
  })

  it('when accept fires and delete fails: toasts error and does NOT call refresh', async () => {
    mockDeleteEq.mockResolvedValue({ error: { message: 'DB error' } })
    const refresh = vi.fn().mockResolvedValue(undefined)
    const { confirmDelete } = useAdminDelete('articles', 'Article', refresh)

    confirmDelete('abc-123')

    const { accept } = mockConfirmRequire.mock.calls[0][0] as { accept: () => Promise<void> }
    await accept()

    expect(mockToastAdd).toHaveBeenCalledWith(
      expect.objectContaining({ severity: 'error' }),
    )
    expect(refresh).not.toHaveBeenCalled()
  })

  it('when onDeleted option is provided and delete succeeds: calls onDeleted with id before refresh', async () => {
    const callOrder: string[] = []
    const refresh = vi.fn().mockImplementation(async () => { callOrder.push('refresh') })
    const onDeleted = vi.fn().mockImplementation(async () => { callOrder.push('onDeleted') })
    const { confirmDelete } = useAdminDelete('articles', 'Article', refresh, { onDeleted })

    confirmDelete('abc-123')

    const { accept } = mockConfirmRequire.mock.calls[0][0] as { accept: () => Promise<void> }
    await accept()

    expect(onDeleted).toHaveBeenCalledWith('abc-123')
    expect(callOrder).toEqual(['onDeleted', 'refresh'])
  })
})
