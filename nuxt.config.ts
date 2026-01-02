import {customTheme} from './primevue-theme'

export default defineNuxtConfig({
    compatibilityDate: '2025-07-15',
    devtools: {enabled: true},
    modules: [
        '@nuxt/icon',
        '@nuxtjs/supabase',
        '@nuxtjs/tailwindcss',
        '@primevue/nuxt-module'
    ],

    app: {
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

    runtimeConfig: {
        public: {
            appName: 'Marek Schir  Portfolio',
            defaultTitle: 'Marek Schir Developer Portfolio Site',
            siteUrl: process.env.SITE_URL || 'http://localhost:3000',
            port: parseInt(process.env.PORT || '3000'),
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
        redirectOptions: {
            login: '/login',
            exclude: ['/**'],
            callback: '/callback'
        }
    },
})