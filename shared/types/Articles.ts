import type { Database } from '#shared/types/database.types'

export type Article = Database['public']['Tables']['articles']['Row']
export type ArticleCategory = Database['public']['Tables']['article_categories']['Row']
export type ArticleTag = Database['public']['Tables']['article_tags']['Row']
export type ArticleSeries = Database['public']['Tables']['article_series']['Row']

export type ArticleListItem = Pick<Article, 'id' | 'title' | 'slug' | 'author' | 'created_at' | 'image_url'> & {
  article_categories: Pick<ArticleCategory, 'name' | 'slug'> | null
}

export type ArticleDetail = Pick<Article, 'id' | 'title' | 'content' | 'created_at'> & {
  article_categories: Pick<ArticleCategory, 'name'> | null
}

export type WritingStage = 'idea' | 'outline' | 'draft' | 'ready'

export type ArticleAdminListItem = Pick<Article, 'id' | 'title' | 'writing_stage' | 'published_at' | 'created_at'> & {
  article_categories: Pick<ArticleCategory, 'name'> | null
  article_series: Pick<ArticleSeries, 'title'> | null
}