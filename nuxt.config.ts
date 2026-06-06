import {customTheme} from './primevue-theme'
import {fileURLToPath} from 'node:url'

export default defineNuxtConfig({
    compatibilityDate: '2026-01-10',
    alias: {
        '#tests': fileURLToPath(new URL('./test', import.meta.url)),
    },
    devtools: {enabled: process.env.NODE_ENV !== 'production'},
    modules: ['@nuxtjs/color-mode', '@nuxt/icon', '@nuxtjs/supabase', '@nuxtjs/tailwindcss', '@primevue/nuxt-module', '@nuxtjs/turnstile', '@nuxt/test-utils/module', 'nuxt-gtag', '@nuxtjs/seo'],

    turnstile: {
        siteKey: '', // NUXT_PUBLIC_TURNSTILE_SITE_KEY
    },

    colorMode: {
        preference: 'system',
        fallback: 'dark',
        classSuffix: '-mode',
        storageKey: 'color-mode',
    },

    site: {
        url: process.env.SITE_URL || 'https://mschir.dev',
        name: 'Marek Schir',
        description: 'Software and integrations for growing businesses.',
        defaultLocale: 'en',
    },

    robots: {
        robotsTxt: true,
        disallow: ['/admin', '/login', '/register', '/callback', '/prototype'],
    },

    sitemap: {
        sources: ['/api/__sitemap__/urls'],
    },

    app: {
        pageTransition: {name: 'page', mode: 'out-in'},
        head: {
            htmlAttrs: {
                lang: 'en',
            },
            link: [
                {
                    rel: 'icon',
                    type: 'image/gif',
                    href: '/favicon.gif'
                },
                {rel: 'preconnect', href: 'https://fonts.googleapis.com'},
                {rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: ''},
                {
                    rel: 'stylesheet',
                    href: 'https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,700;9..144,900&family=Inter:wght@400;500;600;700&display=swap'
                }
            ]
        }
    },

    css: [
        'primeicons/primeicons.css',
        '~/assets/css/main.css',
    ],

    runtimeConfig: {
        turnstile: {
            secretKey: '', // NUXT_TURNSTILE_SECRET_KEY
        },
        resendApiKey: '',         // NUXT_RESEND_API_KEY
        public: {
            appName: 'Marek Schir Portfolio',
            defaultTitle: 'Marek Schir Developer Portfolio Site',
            siteUrl: process.env.SITE_URL || 'http://localhost:3000',
        }
    },

    gtag: {
        id: 'G-TBFLGWRP7Y',
        enabled: process.env.NODE_ENV === 'production',
        initCommands: [
            ['consent', 'default', {
                ad_storage: 'denied',
                ad_user_data: 'denied',
                ad_personalization: 'denied',
                analytics_storage: 'denied',
                wait_for_update: 500,
            }]
        ]
    },

    primevue: {
        components: {
            prefix: 'p',
            include: [
                'InputText',
                'IconField',
                'InputIcon',
                'FloatLabel',
                'IftaLabel',
                'InputNumber',
                'InputGroup',
                'Select',
                'MultiSelect',
                'TextArea',
                'ToggleButton',
                'ToggleSwitch',
                'SelectButton',
                'Editor',
                'DatePicker',
                'ColorPicker',
                'Checkbox',
                'RadioButton',
                'RadioGroup',
                'Form',
                'FormField',
                'Password',
                'Button',
                'Toast',
                'Message',
                'MenuBar',
                'Avatar',
                'Badge',
                'Menu',
                'Dialog',
                'Panel',
                'Card',
                'Toolbar',
                'AutoComplete',
                'DataView',
                'DataTable',
                'Column',
                'Tag',
                'Chip',
                'Tabs',
                'Tab',
                'TabList',
                'TabPanels',
                'TabPanel',
                'FileUpload',
                'Knob',
                'ConfirmPopup',
                'ConfirmDialog',
                'Chart',
                'OverlayBadge',
                'Drawer',
                'Popover',
                'Inplace',
                'AvatarGroup',
                'Timeline',
                'MenuItem',
                'TieredMenu',
                'ProgressSpinner',
                'Breadcrumb',
            ]
        },
        options: {
            ripple: true,
            theme: {
                preset: customTheme,
                options: {
                    prefix: 'p',
                    darkModeSelector: '.dark-mode',
                    cssLayer: false
                }
            }
        }
    },

    supabase: {
        types: '~~/shared/types/database.types.ts',
        redirectOptions: {
            login: '/login',
            exclude: ['/**'],
            callback: '/callback'
        }
    },

})