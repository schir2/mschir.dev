import { it, expect, describe } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'
import ArticleCard from '../../../../app/components/article/ArticleCard.vue'
import type { ArticleCardItem } from '#shared/types/Articles'

const baseArticle: ArticleCardItem = {
  id: 'art-1',
  title: 'Getting Started with Nuxt',
  slug: 'getting-started-with-nuxt',
  published_at: '2026-03-15T00:00:00Z',
  image_url: 'https://example.com/hero.png',
  series_id: 'series-1',
  series_sequence_number: 2,
  article_categories: { name: 'Programming', slug: 'programming' },
  article_tags_links: [
    { article_tags: { name: 'Vue', slug: 'vue' } },
    { article_tags: { name: 'Nuxt', slug: 'nuxt' } },
  ],
  article_series: { title: 'Nuxt Deep Dives', slug: 'nuxt-deep-dives' },
}

describe('ArticleCard', () => {
  it('renders title as a link to /articles/[slug]', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    const titleLink = wrapper.find('a[href="/articles/getting-started-with-nuxt"]')
    expect(titleLink.text()).toContain('Getting Started with Nuxt')
  })

  it('renders hero image when image_url is present', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    const image = wrapper.find('img')
    expect(image.exists()).toBe(true)
    expect(image.attributes('src')).toBe('https://example.com/hero.png')
  })

  it('does not render an image when image_url is null', async () => {
    const noImage: ArticleCardItem = { ...baseArticle, image_url: null }
    const wrapper = await mountSuspended(ArticleCard, { props: { article: noImage } })
    expect(wrapper.find('img').exists()).toBe(false)
  })

  it('renders category chip linking to /articles/browse?category=[slug]', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    const categoryLink = wrapper.find('a[href="/articles/browse?category=programming"]')
    expect(categoryLink.text()).toContain('Programming')
  })

  it('renders no category chip when category is null', async () => {
    const noCategory: ArticleCardItem = { ...baseArticle, article_categories: null }
    const wrapper = await mountSuspended(ArticleCard, { props: { article: noCategory } })
    expect(wrapper.find('a[href*="category="]').exists()).toBe(false)
  })

  it('renders tag chips linking to /articles/browse?tag=[slug]', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    expect(wrapper.find('a[href="/articles/browse?tag=vue"]').exists()).toBe(true)
    expect(wrapper.find('a[href="/articles/browse?tag=nuxt"]').exists()).toBe(true)
  })

  it('renders at most 3 tag chips when more than 3 tags are present', async () => {
    const manyTags: ArticleCardItem = {
      ...baseArticle,
      article_tags_links: [
        { article_tags: { name: 'Vue', slug: 'vue' } },
        { article_tags: { name: 'Nuxt', slug: 'nuxt' } },
        { article_tags: { name: 'TypeScript', slug: 'typescript' } },
        { article_tags: { name: 'Vite', slug: 'vite' } },
      ],
    }
    const wrapper = await mountSuspended(ArticleCard, { props: { article: manyTags } })
    const tagLinks = wrapper.findAll('a[href*="/articles/browse?tag="]')
    expect(tagLinks).toHaveLength(3)
  })

  it('renders the formatted publish date', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    expect(wrapper.text()).toContain('2026')
  })

  it('renders a series badge linking to /articles/series/[slug] when in a series', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    const seriesLink = wrapper.find('a[href="/articles/series/nuxt-deep-dives"]')
    expect(seriesLink.exists()).toBe(true)
    expect(seriesLink.text()).toContain('Nuxt Deep Dives')
  })

  it('renders no series badge when article is not in a series', async () => {
    const noSeries: ArticleCardItem = { ...baseArticle, series_id: null, article_series: null }
    const wrapper = await mountSuspended(ArticleCard, { props: { article: noSeries } })
    expect(wrapper.find('a[href*="/articles/series/"]').exists()).toBe(false)
  })
})
