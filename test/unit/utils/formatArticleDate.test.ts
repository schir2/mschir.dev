import { it, expect, describe } from 'vitest'
import { formatArticleDate } from '../../../app/utils/formatArticleDate'

describe('formatArticleDate', () => {
  it('returns empty string for null input', () => {
    expect(formatArticleDate(null)).toBe('')
  })

  it('returns formatted date string for a valid ISO date string', () => {
    expect(formatArticleDate('2024-09-12T12:00:00Z')).toBe('September 12, 2024')
  })

  it('uses en-US locale with long month, numeric day, and numeric year', () => {
    expect(formatArticleDate('2025-01-05T12:00:00Z')).toBe('January 5, 2025')
  })
})
