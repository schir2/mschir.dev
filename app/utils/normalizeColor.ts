export function normalizeColor(raw: string): string | null {
  if (!raw || raw.trim() === '') return null
  return raw.startsWith('#') ? raw : `#${raw}`
}
