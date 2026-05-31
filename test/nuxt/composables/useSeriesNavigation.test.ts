import { describe, it, expect } from 'vitest'

const articleOne = { id: '1', title: 'First Article', slug: 'first-article', series_sequence_number: 1 }
const articleTwo = { id: '2', title: 'Second Article', slug: 'second-article', series_sequence_number: 2 }
const articleThree = { id: '3', title: 'Third Article', slug: 'third-article', series_sequence_number: 3 }
const allThree = [articleOne, articleTwo, articleThree]

describe('useSeriesNavigation', () => {
  it('previousArticle is null when current is the first in the series', () => {
    const { previousArticle } = useSeriesNavigation(articleOne, allThree)
    expect(previousArticle.value).toBeNull()
  })

  it('nextArticle is null when current is the last in the series', () => {
    const { nextArticle } = useSeriesNavigation(articleThree, allThree)
    expect(nextArticle.value).toBeNull()
  })

  it('previousArticle and nextArticle are correct for a mid-series article', () => {
    const { previousArticle, nextArticle } = useSeriesNavigation(articleTwo, allThree)
    expect(previousArticle.value?.id).toBe(articleOne.id)
    expect(nextArticle.value?.id).toBe(articleThree.id)
  })

  it('currentIndex is 0 for the first, 1 for the second, 2 for the third', () => {
    expect(useSeriesNavigation(articleOne, allThree).currentIndex.value).toBe(0)
    expect(useSeriesNavigation(articleTwo, allThree).currentIndex.value).toBe(1)
    expect(useSeriesNavigation(articleThree, allThree).currentIndex.value).toBe(2)
  })

  it('returns nulls and empty allArticles when siblings list is empty', () => {
    const { previousArticle, nextArticle, allArticles, currentIndex } = useSeriesNavigation(articleOne, [])
    expect(previousArticle.value).toBeNull()
    expect(nextArticle.value).toBeNull()
    expect(allArticles.value).toEqual([])
    expect(currentIndex.value).toBe(-1)
  })
})