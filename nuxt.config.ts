// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    compatibilityDate: '2025-07-15',
    devtools: {enabled: true},
    modules: ['@nuxt/icon', '@nuxtjs/supabase', '@nuxtjs/tailwindcss'],

    app: {
        head: {
            title: 'mschir.dev',
            htmlAttrs: {
                lang: 'en',
                class: 'dark-mode',
            }
        }
    },

    runtimeConfig: {
        public: {
            appName: 'Marek Schir  Portfolio',
            defaultTitle: 'Marek Schir Developer Portfolio Site',
            siteUrl: process.env.SITE_URL || 'http://localhost:3000',
            port: parseInt(process.env.PORT || '3000'),
        }
    },

    supabase: {
        redirectOptions: {
            login: '/login',
            exclude: ['/', '/register', '/docs', '/features', '/faq', '/callback', '/project-invites/**'],
            callback: '/callback'
        }
    },
})