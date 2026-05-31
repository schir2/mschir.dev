import { it, expect, describe } from 'vitest'
import { deriveArticleStatus } from '../../../app/utils/deriveArticleStatus'

describe('deriveArticleStatus', () => {
  it('returns writing stage label and secondary severity when both timestamps are null', () => {
    const result = deriveArticleStatus(null, null, 'draft')
    expect(result).toEqual({ label: 'draft', severity: 'secondary' })
  })

  it('returns Published and success severity when published_at is set and archived_at is null', () => {
    const result = deriveArticleStatus('2026-05-01T00:00:00Z', null, 'ready')
    expect(result).toEqual({ label: 'Published', severity: 'success' })
  })

  it('returns Archived and warn severity when both timestamps are set', () => {
    const result = deriveArticleStatus('2026-05-01T00:00:00Z', '2026-06-01T00:00:00Z', 'ready')
    expect(result).toEqual({ label: 'Archived', severity: 'warn' })
  })
})
