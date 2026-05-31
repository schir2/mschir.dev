import { defineConfig } from 'vitest/config'
import { defineVitestProject } from '@nuxt/test-utils/config'
import { fileURLToPath } from 'node:url'

export default defineConfig({
    resolve: {
        alias: {
            '~': fileURLToPath(new URL('./', import.meta.url)),
            '@': fileURLToPath(new URL('./', import.meta.url)),
            '#tests': fileURLToPath(new URL('./test', import.meta.url)),
        },
    },
    test: {
        globals: true,

        projects: [
            {
                test: {
                    name: 'unit',
                    include: [
                        'test/unit/*.{test,spec}.ts',
                        'test/unit/**/*.{test,spec}.ts',
                    ],
                    exclude: ['node_modules', 'dist', '.nuxt'],
                    environment: 'node',
                },
            },
            {
                test: {
                    name: 'e2e',
                    include: ['test/e2e/*.{test,spec}.ts'],
                    environment: 'node',
                },
            },
            await defineVitestProject({
                resolve: {
                    alias: {
                        '#tests': fileURLToPath(new URL('./test', import.meta.url)),
                    },
                },
                test: {
                    name: 'nuxt',
                    include: [
                        'test/nuxt/*.{test,spec}.ts',
                        'test/nuxt/**/*.{test,spec}.ts',
                    ],
                    environment: 'nuxt',
                    hookTimeout: 30000,
                },
            }),
        ],
    },
})