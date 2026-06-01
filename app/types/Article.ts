import type { Article } from '#shared/types/Article'

export type Crumb = {
  label: string
  to?: string
}

export type SeriesArticle = Pick<Article, 'id' | 'title' | 'slug' | 'series_sequence_number'>
