import type {Database} from '#shared/types/database.types'

export type Article = Database['public']['Tables']['articles']['Row']
export type ArticleCategory = Database['public']['Tables']['article_categories']['Row']
export type ArticleTag = Database['public']['Tables']['article_tags']['Row']
export type ArticleSeries = Database['public']['Tables']['article_series']['Row']

export type ArticleSeriesSummary = Pick<ArticleSeries, 'id' | 'title' | 'slug' | 'description' | 'image_url'> & {
    article_count: number
}

export type ArticleCardItem =
    Pick<Article, 'id' | 'title' | 'slug' | 'summary' | 'published_at' | 'image_url' | 'series_id' | 'series_sequence_number'>
    & {
    article_categories: Pick<ArticleCategory, 'name' | 'slug' | 'color' | 'image_url'> | null
    article_tags_links: Array<{ article_tags: Pick<ArticleTag, 'name' | 'slug' | 'icon'> }>
    article_series: Pick<ArticleSeries, 'title' | 'slug' | 'image_url'> | null
    featured_articles: { id: string; featured_reason: string | null } | null
}

export type ArticleListItem = Pick<Article, 'id' | 'title' | 'slug' | 'author' | 'created_at' | 'image_url'> & {
    article_categories: Pick<ArticleCategory, 'name' | 'slug'> | null
}

export type ArticleDetail = Pick<Article,
    'id' | 'title' | 'slug' | 'content' | 'image_url' | 'published_at' | 'archived_at' |
    'view_count' | 'series_id' | 'series_sequence_number'
> & {
    article_categories: Pick<ArticleCategory, 'name' | 'slug'> | null
    article_tags_links: Array<{ article_tags: Pick<ArticleTag, 'name' | 'slug' | 'icon'> }>
    article_series: Pick<ArticleSeries, 'title' | 'slug' | 'description'> | null
}

export type WritingStage = 'idea' | 'outline' | 'draft' | 'ready'

export type ArticleAdminListItem =
    Pick<Article, 'id' | 'title' | 'writing_stage' | 'published_at' | 'archived_at' | 'created_at'>
    & {
    article_categories: Pick<ArticleCategory, 'name'> | null
    article_series: Pick<ArticleSeries, 'title'> | null
    featured_articles: { id: string; featured_reason: string | null } | null
}