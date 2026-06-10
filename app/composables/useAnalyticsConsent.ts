export function analyticsConsentPayload(
  enabledIds: string[] | null | undefined,
): { analytics_storage: 'granted' | 'denied' } {
  return { analytics_storage: enabledIds?.includes('ga') ? 'granted' : 'denied' }
}

export function useAnalyticsConsent(): void {
  const { cookiesEnabledIds } = useCookieControl()
  const { gtag } = useGtag()

  watch(
    cookiesEnabledIds,
    (enabledIds) => {
      gtag('consent', 'update', analyticsConsentPayload(enabledIds))
    },
    { immediate: true },
  )
}