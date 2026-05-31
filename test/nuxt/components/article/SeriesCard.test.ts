import { it, expect, describe } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'
import SeriesCard from '../../../../app/components/article/SeriesCard.vue'
import type { ArticleSeriesSummary } from '#shared/types/Articles'

const baseSeries: ArticleSeriesSummary = {
  id: 'series-1',
  title: 'Nuxt Deep Dives',
  slug: 'nuxt-deep-dives',
  description: 'A thorough look at Nuxt internals.',
  article_count: 4,
}

describe('SeriesCard', () => {
  it('renders the series title', async () => {
    const wrapper = await mountSuspended(SeriesCard, { props: { series: baseSeries } })
    expect(wrapper.text()).toContain('Nuxt Deep Dives')
  })

  it('renders the series description', async () => {
    const wrapper = await mountSuspended(SeriesCard, { props: { series: baseSeries } })
    expect(wrapper.text()).toContain('A thorough look at Nuxt internals.')
  })

  it('renders the article count', async () => {
    const wrapper = await mountSuspended(SeriesCard, { props: { series: baseSeries } })
    expect(wrapper.text()).toContain('4')
  })

  it('link points to /articles/series/[slug]', async () => {
    const wrapper = await mountSuspended(SeriesCard, { props: { series: baseSeries } })
    const link = wrapper.find('a')
    expect(link.attributes('href')).toBe('/articles/series/nuxt-deep-dives')
  })
})
