import { serverSupabaseServiceRole } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const client = serverSupabaseServiceRole(event)

  const [
    { data: articles },
    { data: projects },
    { data: series },
  ] = await Promise.all([
    client
      .from('articles')
      .select('slug, updated_at')
      .not('published_at', 'is', null)
      .is('archived_at', null),
    client
      .from('projects')
      .select('slug, updated_at'),
    client
      .from('article_series')
      .select('slug, updated_at'),
  ])

  return [
    ...(articles ?? []).map(article => ({
      loc: `/articles/${article.slug}`,
      lastmod: article.updated_at,
    })),
    ...(projects ?? []).map(project => ({
      loc: `/projects/${project.slug}`,
      lastmod: project.updated_at,
    })),
    ...(series ?? []).map(seriesItem => ({
      loc: `/articles/series/${seriesItem.slug}`,
      lastmod: seriesItem.updated_at,
    })),
  ]
})
