import type { Database } from '#shared/types/database.types'

export type Article = Database['public']['Tables']['articles']['Row']
export type ArticleTopic = Database['public']['Tables']['article_topics']['Row']

export type ArticleListItem = Pick<Article, 'id' | 'title' | 'slug' | 'author' | 'created_at' | 'image_url'> & {
  article_topics: Pick<ArticleTopic, 'name' | 'slug'> | null
}