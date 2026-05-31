import { it, expect, describe } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'
import ArticleArchivedBanner from '../../../../app/components/article/ArticleArchivedBanner.vue'

describe('ArticleArchivedBanner', () => {
  it('renders a visible archived warning when archivedAt is set', async () => {
    const wrapper = await mountSuspended(ArticleArchivedBanner, {
      props: { archivedAt: '2026-05-01T00:00:00Z' },
    })
    expect(wrapper.text()).toBeTruthy()
  })

  it('renders nothing when archivedAt is null', async () => {
    const wrapper = await mountSuspended(ArticleArchivedBanner, {
      props: { archivedAt: null },
    })
    expect(wrapper.text()).toBe('')
  })

  it('banner text communicates the content may be outdated', async () => {
    const wrapper = await mountSuspended(ArticleArchivedBanner, {
      props: { archivedAt: '2026-05-01T00:00:00Z' },
    })
    expect(wrapper.text().toLowerCase()).toContain('outdated')
  })
})
