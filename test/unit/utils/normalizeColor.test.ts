import { it, expect, describe } from 'vitest'
import { normalizeColor } from '../../../app/utils/normalizeColor'

describe('normalizeColor', () => {
  it('returns null for an empty string', () => {
    expect(normalizeColor('')).toBeNull()
  })

  it('returns null for a whitespace-only string', () => {
    expect(normalizeColor('   ')).toBeNull()
  })

  it('returns the value unchanged when it already starts with #', () => {
    expect(normalizeColor('#ff0000')).toBe('#ff0000')
  })

  it('prepends # when the value does not start with #', () => {
    expect(normalizeColor('ff0000')).toBe('#ff0000')
  })
})
