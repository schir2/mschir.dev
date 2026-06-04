import { describe, it, expect, vi } from 'vitest'
import { mountPage } from '#tests/helpers/page'
import BrowsePage from '../../../../app/pages/articles/browse.vue'
import CategoryTagFilter from '../../../../app/components/article/CategoryTagFilter.vue'

describe('articles/browse', () => {
  it('renders seeded categories from Supabase', async () => {
    const { wrapper } = await mountPage(BrowsePage)
    await vi.waitFor(() => expect(wrapper.text()).toContain('Web Development'))
  })

  it('seeds modelCategory from the category query param', async () => {
    const { wrapper } = await mountPage(BrowsePage, { query: { category: 'web-development' } })
    await vi.waitFor(() =>
      expect(wrapper.findComponent(CategoryTagFilter).props('modelCategory')).toBe('web-development'),
    )
  })
})