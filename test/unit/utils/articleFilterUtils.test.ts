import { it, expect, describe } from 'vitest'
import type { ArticleCardItem } from '#shared/types/Articles'
import { filterArticles } from '../../../app/utils/articleFilterUtils'

const makeArticle = (overrides: Partial<ArticleCardItem> = {}): ArticleCardItem => ({
  id: 'art-1',
  title: 'Test Article',
  slug: 'test-article',
  published_at: '2026-01-01T00:00:00Z',
  image_url: null,
  series_id: null,
  series_sequence_number: null,
  article_categories: { name: 'Programming', slug: 'programming' },
  article_tags_links: [{ article_tags: { name: 'Vue', slug: 'vue' } }],
  article_series: null,
  ...overrides,
})

const programmingArticle = makeArticle({ id: 'art-1', article_categories: { name: 'Programming', slug: 'programming' } })
const designArticle = makeArticle({ id: 'art-2', article_categories: { name: 'Design', slug: 'design' } })
const vueTagArticle = makeArticle({ id: 'art-3', article_tags_links: [{ article_tags: { name: 'Vue', slug: 'vue' } }] })
const tsTagArticle = makeArticle({ id: 'art-4', article_tags_links: [{ article_tags: { name: 'TypeScript', slug: 'typescript' } }] })
const bothTagsArticle = makeArticle({
  id: 'art-5',
  article_tags_links: [
    { article_tags: { name: 'Vue', slug: 'vue' } },
    { article_tags: { name: 'TypeScript', slug: 'typescript' } },
  ],
})

describe('filterArticles', () => {
  it('returns all articles when no filters are active', () => {
    const articles = [programmingArticle, designArticle]
    expect(filterArticles(articles, null, [])).toEqual(articles)
  })

  it('returns only articles in the active category', () => {
    const articles = [programmingArticle, designArticle]
    expect(filterArticles(articles, 'programming', [])).toEqual([programmingArticle])
  })

  it('returns only articles that have the active tag', () => {
    const articles = [vueTagArticle, tsTagArticle]
    expect(filterArticles(articles, null, ['vue'])).toEqual([vueTagArticle])
  })

  it('requires all active tags to be present (AND logic)', () => {
    const articles = [vueTagArticle, tsTagArticle, bothTagsArticle]
    expect(filterArticles(articles, null, ['vue', 'typescript'])).toEqual([bothTagsArticle])
  })

  it('applies category and tag filters together (AND logic)', () => {
    const programmingVueArticle = makeArticle({
      id: 'art-6',
      article_categories: { name: 'Programming', slug: 'programming' },
      article_tags_links: [{ article_tags: { name: 'Vue', slug: 'vue' } }],
    })
    const programmingTsArticle = makeArticle({
      id: 'art-7',
      article_categories: { name: 'Programming', slug: 'programming' },
      article_tags_links: [{ article_tags: { name: 'TypeScript', slug: 'typescript' } }],
    })
    const articles = [programmingVueArticle, programmingTsArticle, designArticle]
    expect(filterArticles(articles, 'programming', ['vue'])).toEqual([programmingVueArticle])
  })

  it('returns empty array when no articles match active filters', () => {
    const articles = [programmingArticle, designArticle]
    expect(filterArticles(articles, 'nonexistent-category', [])).toEqual([])
  })

  it('excludes articles with null category when a category filter is active', () => {
    const noCategoryArticle = makeArticle({ id: 'art-8', article_categories: null })
    const articles = [noCategoryArticle, programmingArticle]
    expect(filterArticles(articles, 'programming', [])).toEqual([programmingArticle])
  })

  it('excludes articles with no tags when a tag filter is active', () => {
    const noTagsArticle = makeArticle({ id: 'art-9', article_tags_links: [] })
    const articles = [noTagsArticle, vueTagArticle]
    expect(filterArticles(articles, null, ['vue'])).toEqual([vueTagArticle])
  })
})