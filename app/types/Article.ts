import type { Article } from '#shared/types/Article'

export type SeriesArticle = Pick<Article, 'id' | 'title' | 'slug' | 'series_sequence_number'>
