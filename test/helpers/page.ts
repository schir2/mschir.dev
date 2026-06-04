import { mountSuspended } from '@nuxt/test-utils/runtime'
import { flushPromises } from '@vue/test-utils'
import { vi } from 'vitest'
import type { Component } from 'vue'

interface MountPageOptions {
  query?: Record<string, string | string[]>
  path?: string
}

function buildRouteString(path: string, query: Record<string, string | string[]>): string {
  const params = new URLSearchParams()
  for (const [key, value] of Object.entries(query)) {
    if (Array.isArray(value)) {
      for (const entry of value) params.append(key, entry)
    } else {
      params.set(key, value)
    }
  }
  const queryString = params.toString()
  return queryString ? `${path}?${queryString}` : path
}

export async function mountPage(component: Component, options: MountPageOptions = {}) {
  const { query = {}, path = '/' } = options
  const route = buildRouteString(path, query)

  const wrapper = await mountSuspended(component, { route })
  await flushPromises()

  const router = useRouter()
  vi.spyOn(router, 'replace')
  vi.spyOn(router, 'push')

  return { wrapper, router }
}