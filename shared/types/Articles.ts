import type { Database } from '#shared/types/database.types'

export type Article = Database['public']['Tables']['articles']['Row']
export type ArticleTopic = Database['public']['Tables']['article_topics']['Row']
export type ArticleTag = Database['public']['Tables']['article_tags']['Row']
export type ArticleSeries = Database['public']['Tables']['article_series']['Row']

export type ArticleListItem = Pick<Article, 'id' | 'title' | 'slug' | 'author' | 'created_at' | 'image_url'> & {
  article_topics: Pick<ArticleTopic, 'name' | 'slug'> | null
}

export type ArticleDetail = Pick<Article, 'id' | 'title' | 'content' | 'created_at'> & {
  article_topics: Pick<ArticleTopic, 'name'> | null
}

export type ArticleAdminListItem = Pick<Article, 'id' | 'title' | 'is_published' | 'created_at'> & {
  article_topics: Pick<ArticleTopic, 'name'> | null
  article_series: Pick<ArticleSeries, 'title'> | null
}