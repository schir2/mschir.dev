import { it, expect, describe } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'
import ArticleCard from '../../../../app/components/article/ArticleCard.vue'
import type { ArticleCardItem } from '#shared/types/Article'

const baseArticle: ArticleCardItem = {
  id: 'art-1',
  title: 'Getting Started with Nuxt',
  slug: 'getting-started-with-nuxt',
  published_at: '2026-03-15T00:00:00Z',
  image_url: null,
  summary: 'An introduction to Nuxt 4 for beginners.',
  series_id: 'series-1',
  series_sequence_number: 2,
  featured_articles: null,
  article_categories: { name: 'Programming', slug: 'programming', color: '#4f46e5', image_url: null },
  article_tags_links: [
    { article_tags: { name: 'Vue', slug: 'vue' } },
    { article_tags: { name: 'Nuxt', slug: 'nuxt' } },
  ],
  article_series: { title: 'Nuxt Deep Dives', slug: 'nuxt-deep-dives', image_url: null },
}

describe('ArticleCard', () => {
  it('renders title as a link to /articles/[slug]', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    const titleLink = wrapper.find('a[href="/articles/getting-started-with-nuxt"]')
    expect(titleLink.text()).toContain('Getting Started with Nuxt')
  })

  it('renders hero image when image_url is a full URL', async () => {
    const article: ArticleCardItem = { ...baseArticle, image_url: 'https://example.com/hero.png' }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    const image = wrapper.find('img')
    expect(image.exists()).toBe(true)
    expect(image.attributes('src')).toBe('https://example.com/hero.png')
  })

  it('does not render an img when thumbnail resolves to a color', async () => {
    const article: ArticleCardItem = {
      ...baseArticle,
      image_url: null,
      article_series: { title: 'Nuxt Deep Dives', slug: 'nuxt-deep-dives', image_url: null },
      article_categories: { name: 'Programming', slug: 'programming', color: '#ff0000', image_url: null },
    }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    expect(wrapper.find('img').exists()).toBe(false)
  })

  it('renders category dot linking to /articles/browse?category=[slug]', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    const categoryLink = wrapper.find('a[href="/articles/browse?category=programming"]')
    expect(categoryLink.exists()).toBe(true)
    expect(categoryLink.text()).toContain('Programming')
  })

  it('renders category dot with the category color as background', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    const dot = wrapper.find('[data-testid="category-dot"]')
    expect(dot.exists()).toBe(true)
    expect(dot.attributes('style')).toContain('#4f46e5')
  })

  it('renders no category when article_categories is null', async () => {
    const article: ArticleCardItem = { ...baseArticle, article_categories: null }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    expect(wrapper.find('a[href*="category="]').exists()).toBe(false)
  })

  it('renders tag links to /articles/browse?tag=[slug]', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    expect(wrapper.find('a[href="/articles/browse?tag=vue"]').exists()).toBe(true)
    expect(wrapper.find('a[href="/articles/browse?tag=nuxt"]').exists()).toBe(true)
  })

  it('renders at most 3 tag links when more than 3 tags are present', async () => {
    const article: ArticleCardItem = {
      ...baseArticle,
      article_tags_links: [
        { article_tags: { name: 'Vue', slug: 'vue' } },
        { article_tags: { name: 'Nuxt', slug: 'nuxt' } },
        { article_tags: { name: 'TypeScript', slug: 'typescript' } },
        { article_tags: { name: 'Vite', slug: 'vite' } },
      ],
    }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    expect(wrapper.findAll('a[href*="/articles/browse?tag="]')).toHaveLength(3)
  })

  it('renders a "+N" badge when there are more than 3 tags', async () => {
    const article: ArticleCardItem = {
      ...baseArticle,
      article_tags_links: [
        { article_tags: { name: 'Vue', slug: 'vue' } },
        { article_tags: { name: 'Nuxt', slug: 'nuxt' } },
        { article_tags: { name: 'TypeScript', slug: 'typescript' } },
        { article_tags: { name: 'Vite', slug: 'vite' } },
        { article_tags: { name: 'Tailwind', slug: 'tailwind' } },
      ],
    }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    const badge = wrapper.find('[data-testid="hidden-tag-count"]')
    expect(badge.exists()).toBe(true)
    expect(badge.text()).toBe('+2')
  })

  it('renders no "+N" badge when there are 3 or fewer tags', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    expect(wrapper.find('[data-testid="hidden-tag-count"]').exists()).toBe(false)
  })

  it('renders the formatted publish date', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    expect(wrapper.text()).toContain('2026')
  })

  it('renders series as "Part N of · title" with a link to /articles/series/[slug]', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    const seriesLink = wrapper.find('a[href="/articles/series/nuxt-deep-dives"]')
    expect(seriesLink.exists()).toBe(true)
    expect(seriesLink.text()).toContain('Nuxt Deep Dives')
    expect(wrapper.text()).toContain('Part 2 of')
  })

  it('renders no series row when article_series is null', async () => {
    const article: ArticleCardItem = { ...baseArticle, series_id: null, article_series: null }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    expect(wrapper.find('a[href*="/articles/series/"]').exists()).toBe(false)
    expect(wrapper.text()).not.toContain('Part')
  })

  it('renders summary when present', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    expect(wrapper.text()).toContain('An introduction to Nuxt 4 for beginners.')
  })

  it('does not render the summary element when summary is null', async () => {
    const article: ArticleCardItem = { ...baseArticle, summary: null }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    expect(wrapper.find('[data-testid="article-summary"]').exists()).toBe(false)
  })

  it('renders thumbnail as img when thumbnail resolves to an image URL', async () => {
    const article: ArticleCardItem = { ...baseArticle, image_url: 'https://example.com/thumbnail.png' }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    expect(wrapper.find('[data-testid="article-thumbnail"] img').exists()).toBe(true)
  })

  it('renders thumbnail as a colored div when thumbnail resolves to a color', async () => {
    const article: ArticleCardItem = {
      ...baseArticle,
      image_url: null,
      series_id: null,
      article_series: null,
      article_categories: { name: 'Programming', slug: 'programming', color: '#ff6600', image_url: null },
    }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    const thumbnail = wrapper.find('[data-testid="article-thumbnail"]')
    expect(thumbnail.find('img').exists()).toBe(false)
    expect(thumbnail.attributes('style')).toContain('#ff6600')
  })

  it('does not render the featured bar when featured_articles is null', async () => {
    const wrapper = await mountSuspended(ArticleCard, { props: { article: baseArticle } })
    expect(wrapper.find('[data-testid="featured-bar"]').exists()).toBe(false)
  })

  it('renders the featured bar when featured_articles is present', async () => {
    const article: ArticleCardItem = {
      ...baseArticle,
      featured_articles: { id: 'fa-1', featured_reason: null },
    }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    expect(wrapper.find('[data-testid="featured-bar"]').exists()).toBe(true)
  })

  it('renders the featured reason pill when featured_reason is set', async () => {
    const article: ArticleCardItem = {
      ...baseArticle,
      featured_articles: { id: 'fa-1', featured_reason: 'Staff pick' },
    }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    const pill = wrapper.find('[data-testid="featured-reason"]')
    expect(pill.exists()).toBe(true)
    expect(pill.text()).toBe('Staff pick')
  })

  it('does not render the featured reason pill when featured_reason is null', async () => {
    const article: ArticleCardItem = {
      ...baseArticle,
      featured_articles: { id: 'fa-1', featured_reason: null },
    }
    const wrapper = await mountSuspended(ArticleCard, { props: { article } })
    expect(wrapper.find('[data-testid="featured-reason"]').exists()).toBe(false)
  })
})
