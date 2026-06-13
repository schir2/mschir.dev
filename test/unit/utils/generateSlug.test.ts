import { it, expect, describe } from 'vitest'
import { generateSlug } from '../../../app/utils/generateSlug'

describe('generateSlug', () => {
  it('lowercases and hyphenates a basic title', () => {
    expect(generateSlug('My First Article')).toBe('my-first-article')
  })

  it('strips diacritics from unicode characters', () => {
    expect(generateSlug('Ångström Über café')).toBe('angstrom-uber-cafe')
  })

  it('trims leading and trailing special characters', () => {
    expect(generateSlug('--hello world--')).toBe('hello-world')
  })

  it('collapses consecutive special characters into a single hyphen', () => {
    expect(generateSlug('hello   world!!! foo')).toBe('hello-world-foo')
  })

  it('returns an empty string for empty input', () => {
    expect(generateSlug('')).toBe('')
  })

  it('returns the same value for input that is already a valid slug', () => {
    expect(generateSlug('my-first-article')).toBe('my-first-article')
  })
})