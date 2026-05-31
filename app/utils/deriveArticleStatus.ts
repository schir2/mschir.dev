import type { WritingStage } from '#shared/types/Article'

type ArticleStatus = {
  label: string
  severity: 'success' | 'warn' | 'secondary'
}

export function deriveArticleStatus(
  publishedAt: string | null,
  archivedAt: string | null,
  writingStage: WritingStage,
): ArticleStatus {
  if (publishedAt && archivedAt) return { label: 'Archived', severity: 'warn' }
  if (publishedAt) return { label: 'Published', severity: 'success' }
  return { label: writingStage, severity: 'secondary' }
}
