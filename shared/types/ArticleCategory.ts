import type { Database } from '#shared/types/database.types'

export type ArticleCategory = Database['public']['Tables']['article_categories']['Row']
export type ArticleCategoryInsert = Database['public']['Tables']['article_categories']['Insert']
export type ArticleCategoryUpdate = Database['public']['Tables']['article_categories']['Update']
