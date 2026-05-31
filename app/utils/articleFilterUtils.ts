import type { ArticleCardItem } from '#shared/types/Articles'

export function filterArticles(
  articles: ArticleCardItem[],
  activeCategory: string | null,
  activeTags: string[],
): ArticleCardItem[] {
  return articles.filter((article) => {
    const categoryMatch = !activeCategory || article.article_categories?.slug === activeCategory
    const tagMatch = activeTags.length === 0 || activeTags.every((tagSlug) =>
      article.article_tags_links.some((link) => link.article_tags.slug === tagSlug),
    )
    return categoryMatch && tagMatch
  })
}
