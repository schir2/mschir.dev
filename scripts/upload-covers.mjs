/**
 * Uploads article and project cover images to Supabase Storage and updates
 * the corresponding image_url fields in the database.
 *
 * Folder structure:
 *   supabase/seed-assets/covers/articles/<slug>/cover.png  (any filename works)
 *   supabase/seed-assets/covers/projects/<slug>/cover.png
 *
 * Drop any image file into the slug folder and run this script.
 * Empty slug folders are skipped automatically.
 *
 * Usage:
 *   node --env-file=.env scripts/upload-covers.mjs
 *
 * Required env vars:
 *   SUPABASE_URL              — local: http://localhost:54321, prod: https://<ref>.supabase.co
 *   SUPABASE_SERVICE_ROLE_KEY — from `supabase status` locally, or the Supabase dashboard
 */

import { createClient } from '@supabase/supabase-js'
import { readdir, readFile } from 'node:fs/promises'
import { extname, resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = resolve(__dirname, '..')

const SUPABASE_URL = process.env.SUPABASE_URL
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
    console.error('Error: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set.')
    console.error('Run with: node --env-file=.env scripts/upload-covers.mjs')
    process.exit(1)
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

const MIME_TYPES = {
    '.png':  'image/png',
    '.jpg':  'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.webp': 'image/webp',
}

const TARGETS = [
    { dir: 'supabase/seed-assets/covers/articles', storagePath: 'covers/articles', table: 'articles' },
    { dir: 'supabase/seed-assets/covers/projects', storagePath: 'covers/projects', table: 'projects' },
]

async function findImageInFolder(folderPath) {
    const entries = await readdir(folderPath)
    const imageFile = entries.find(name => MIME_TYPES[extname(name).toLowerCase()])
    return imageFile ?? null
}

async function processTarget(target) {
    const baseDir = resolve(ROOT, target.dir)
    const slugDirs = await readdir(baseDir, { withFileTypes: true })
    const folders = slugDirs.filter(entry => entry.isDirectory())

    let uploaded = 0
    let skipped = 0
    let failed = 0

    for (const folder of folders) {
        const slug = folder.name
        const folderPath = resolve(baseDir, slug)
        const imageFile = await findImageInFolder(folderPath)

        if (!imageFile) {
            skipped++
            continue
        }

        const ext = extname(imageFile).toLowerCase()
        const mimeType = MIME_TYPES[ext]
        const objectPath = `${target.storagePath}/${slug}${ext}`
        const fileBuffer = await readFile(resolve(folderPath, imageFile))

        const { error: uploadError } = await supabase.storage
            .from('images')
            .upload(objectPath, fileBuffer, { contentType: mimeType, upsert: true })

        if (uploadError) {
            console.error(`  ✗ ${slug} — upload failed: ${uploadError.message}`)
            failed++
            continue
        }

        const { data: { publicUrl } } = supabase.storage
            .from('images')
            .getPublicUrl(objectPath)

        const { error: updateError, count } = await supabase
            .from(target.table)
            .update({ image_url: publicUrl })
            .eq('slug', slug)
            .select('id', { count: 'exact', head: true })

        if (updateError) {
            console.error(`  ✗ ${slug} — db update failed: ${updateError.message}`)
            failed++
        } else if (count === 0) {
            console.warn(`  ⚠ ${slug} — uploaded but no ${target.table} row matched slug`)
            uploaded++
        } else {
            console.log(`  ✓ ${slug}`)
            uploaded++
        }
    }

    return { uploaded, skipped, failed }
}

async function main() {
    console.log(`Connecting to ${SUPABASE_URL}\n`)

    for (const target of TARGETS) {
        console.log(`${target.table}:`)
        const { uploaded, skipped, failed } = await processTarget(target)
        console.log(`  → ${uploaded} uploaded, ${skipped} skipped (empty), ${failed} failed\n`)
    }
}

main().catch(err => {
    console.error('Unexpected error:', err)
    process.exit(1)
})
