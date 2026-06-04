import type { MaybeRefOrGetter } from 'vue'

export interface PageSeoOptions {
  title: MaybeRefOrGetter<string | undefined>
  description: MaybeRefOrGetter<string | undefined>
  image?: MaybeRefOrGetter<string | undefined>
  type?: 'website' | 'article'
  publishedAt?: MaybeRefOrGetter<string | undefined>
}

export function usePageSeo(options: PageSeoOptions) {
  const config = useRuntimeConfig()
  const route = useRoute()
  const siteUrl = config.public.siteUrl as string
  const defaultImage = `${siteUrl}/seo/og-default.png`

  useHead({
    title: () => toValue(options.title),
    titleTemplate: (title) => title ? `${title} | Marek Schir` : 'Marek Schir',
  })

  useServerSeoMeta({
    description: options.description,
    ogTitle: () => {
      const title = toValue(options.title)
      return title ? `${title} | Marek Schir` : 'Marek Schir'
    },
    ogDescription: options.description,
    ogImage: () => toValue(options.image) ?? defaultImage,
    ogUrl: () => `${siteUrl}${route.path}`,
    ogType: options.type ?? 'website',
    articlePublishedTime: options.type === 'article' ? options.publishedAt : undefined,
    twitterCard: 'summary_large_image',
    twitterImage: () => toValue(options.image) ?? defaultImage,
  })

  useHead({
    link: [{ rel: 'canonical', href: () => `${siteUrl}${route.path}` }],
  })
}