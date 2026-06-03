import type { Database } from '#shared/types/database.types'

export type ArticleSeries = Database['public']['Tables']['article_series']['Row']
export type ArticleSeriesInsert = Database['public']['Tables']['article_series']['Insert']
export type ArticleSeriesUpdate = Database['public']['Tables']['article_series']['Update']
