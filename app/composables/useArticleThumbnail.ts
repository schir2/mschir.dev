import type { ArticleCardItem } from '#shared/types/Article'

const NEUTRAL_FALLBACK = 'var(--p-surface-700)'

type ThumbnailResult = { type: 'image'; url: string } | { type: 'color'; color: string }

export function useArticleThumbnail(article: ArticleCardItem): ThumbnailResult {
  if (article.image_url) return { type: 'image', url: article.image_url }
  if (article.article_series?.image_url) return { type: 'image', url: article.article_series.image_url }
  if (article.article_categories?.image_url) return { type: 'image', url: article.article_categories.image_url }
  if (article.article_categories?.color) return { type: 'color', color: article.article_categories.color }
  return { type: 'color', color: NEUTRAL_FALLBACK }
}
