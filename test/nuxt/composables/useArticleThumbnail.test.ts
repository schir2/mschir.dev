import { describe, it, expect } from 'vitest'
import type { ArticleCardItem } from '#shared/types/Article'

function makeArticle(overrides: Partial<ArticleCardItem> = {}): ArticleCardItem {
  return {
    id: 'a1',
    title: 'Test Article',
    slug: 'test-article',
    summary: null,
    published_at: '2026-01-01T00:00:00Z',
    image_url: null,
    series_id: null,
    series_sequence_number: null,
    article_categories: null,
    article_tags_links: [],
    article_series: null,
    ...overrides,
  }
}

describe('useArticleThumbnail', () => {
  it('returns article image when article has image_url', () => {
    const article = makeArticle({ image_url: 'article-heroes/abc.jpg' })
    expect(useArticleThumbnail(article)).toEqual({ type: 'image', url: 'article-heroes/abc.jpg' })
  })

  it('returns series image when article image is null but series has image_url', () => {
    const article = makeArticle({
      image_url: null,
      article_series: { title: 'My Series', slug: 'my-series', image_url: 'series-images/xyz.jpg' },
    })
    expect(useArticleThumbnail(article)).toEqual({ type: 'image', url: 'series-images/xyz.jpg' })
  })

  it('returns category image when article and series images are null but category has image_url', () => {
    const article = makeArticle({
      image_url: null,
      article_series: { title: 'My Series', slug: 'my-series', image_url: null },
      article_categories: { name: 'Dev', slug: 'dev', color: null, image_url: 'category-images/dev.jpg' },
    })
    expect(useArticleThumbnail(article)).toEqual({ type: 'image', url: 'category-images/dev.jpg' })
  })

  it('returns category color when no images exist at any level', () => {
    const article = makeArticle({
      image_url: null,
      article_series: { title: 'My Series', slug: 'my-series', image_url: null },
      article_categories: { name: 'Dev', slug: 'dev', color: '#4f46e5', image_url: null },
    })
    expect(useArticleThumbnail(article)).toEqual({ type: 'color', color: '#4f46e5' })
  })

  it('returns neutral fallback color when all image and color fields are null', () => {
    const article = makeArticle({
      image_url: null,
      article_series: { title: 'My Series', slug: 'my-series', image_url: null },
      article_categories: { name: 'Dev', slug: 'dev', color: null, image_url: null },
    })
    const result = useArticleThumbnail(article)
    expect(result.type).toBe('color')
    expect((result as { type: 'color'; color: string }).color).toBeTruthy()
  })
})
