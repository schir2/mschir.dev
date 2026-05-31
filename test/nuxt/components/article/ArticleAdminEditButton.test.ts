import { describe, it, expect, vi, beforeEach } from 'vitest'
import { ref } from 'vue'
import { mountSuspended, mockNuxtImport } from '@nuxt/test-utils/runtime'
import ArticleAdminEditButton from '../../../../app/components/article/ArticleAdminEditButton.vue'

const mockUser = ref<null | { app_metadata?: { role?: string } }>(null)

mockNuxtImport('useSupabaseUser', () => () => mockUser)

describe('ArticleAdminEditButton', () => {
  beforeEach(() => {
    mockUser.value = null
  })

  it('renders nothing when user is null', async () => {
    const wrapper = await mountSuspended(ArticleAdminEditButton, {
      props: { articleId: 'article-123' },
    })
    expect(wrapper.text()).toBe('')
  })

  it('renders nothing when user is non-admin', async () => {
    mockUser.value = { app_metadata: { role: 'viewer' } }
    const wrapper = await mountSuspended(ArticleAdminEditButton, {
      props: { articleId: 'article-123' },
    })
    expect(wrapper.text()).toBe('')
  })

  it('renders an edit button linking to /admin/articles/[id] for an admin user', async () => {
    mockUser.value = { app_metadata: { role: 'admin' } }
    const wrapper = await mountSuspended(ArticleAdminEditButton, {
      props: { articleId: 'article-123' },
    })
    const link = wrapper.find('a')
    expect(link.exists()).toBe(true)
    expect(link.attributes('href')).toBe('/admin/articles/article-123')
  })
})
