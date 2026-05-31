import {customTheme} from './primevue-theme'
import { fileURLToPath } from 'node:url'

export default defineNuxtConfig({
    compatibilityDate: '2026-01-10',
    alias: {
        '#tests': fileURLToPath(new URL('./test', import.meta.url)),
    },
    devtools: {enabled: true},
    modules: [
        '@nuxt/icon',
        '@nuxtjs/supabase',
        '@nuxtjs/tailwindcss',
        '@primevue/nuxt-module',
        '@pinia/nuxt',
        '@nuxtjs/turnstile',
        '@nuxt/test-utils/module',
    ],

    app: {
        pageTransition: { name: 'page', mode: 'out-in' },
        head: {
            title: 'mschir.dev',
            htmlAttrs: {
                lang: 'en',
                class: 'dark-mode',
            },
            link: [
                {
                    rel: 'icon',
                    type: 'image/gif',
                    href: '/favicon.gif'
                }
            ]
        }
    },

    css: [
        'primeicons/primeicons.css',
    ],

    runtimeConfig: {
        turnstileSecretKey: '',   // NUXT_TURNSTILE_SECRET_KEY
        resendApiKey: '',         // NUXT_RESEND_API_KEY
        public: {
            appName: 'Marek Schir  Portfolio',
            defaultTitle: 'Marek Schir Developer Portfolio Site',
            siteUrl: process.env.SITE_URL || 'http://localhost:3000',
            port: parseInt(process.env.PORT || '3000'),
            turnstileSiteKey: '', // NUXT_PUBLIC_TURNSTILE_SITE_KEY
        }
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
                'Toast',
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
                'Editor',
                'Knob',
                'ConfirmPopup',
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
                'TextArea',
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