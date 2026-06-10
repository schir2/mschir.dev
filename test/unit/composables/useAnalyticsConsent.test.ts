import { describe, it, expect } from 'vitest'
import { analyticsConsentPayload } from '../../../app/composables/useAnalyticsConsent'

describe('analyticsConsentPayload', () => {
  it('returns denied when the list is empty', () => {
    expect(analyticsConsentPayload([])).toEqual({ analytics_storage: 'denied' })
  })

  it('returns denied when ga is not present', () => {
    expect(analyticsConsentPayload(['other_cookie'])).toEqual({ analytics_storage: 'denied' })
  })

  it('returns granted when ga is in the list', () => {
    expect(analyticsConsentPayload(['ga'])).toEqual({ analytics_storage: 'granted' })
  })

  it('returns granted when ga is one of several cookies', () => {
    expect(analyticsConsentPayload(['ga', 'other'])).toEqual({ analytics_storage: 'granted' })
  })

  it('returns denied when the list is null', () => {
    expect(analyticsConsentPayload(null)).toEqual({ analytics_storage: 'denied' })
  })

  it('returns denied when the list is undefined', () => {
    expect(analyticsConsentPayload(undefined)).toEqual({ analytics_storage: 'denied' })
  })
})
