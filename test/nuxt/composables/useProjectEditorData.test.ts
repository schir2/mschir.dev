import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mockNuxtImport } from '@nuxt/test-utils/runtime'

const sampleCompanies = [
  { id: 'c1', name: 'Acme Corp' },
  { id: 'c2', name: 'Beta Ltd' },
]

const sampleSkills = [
  { id: 's1', name: 'TypeScript', skill_categories: { name: 'Languages' } },
  { id: 's2', name: 'Vue', skill_categories: { name: 'Frontend' } },
  { id: 's3', name: 'Nuxt', skill_categories: { name: 'Frontend' } },
  { id: 's4', name: 'PostgreSQL', skill_categories: null },
]

const { mockCompaniesOrder, mockSkillsOrder } = vi.hoisted(() => ({
  mockCompaniesOrder: vi.fn(),
  mockSkillsOrder: vi.fn(),
}))

mockNuxtImport('useSupabaseClient', () => () => ({
  from: (table: string) => ({
    select: () => ({
      order: table === 'companies' ? mockCompaniesOrder : mockSkillsOrder,
    }),
  }),
}))

beforeEach(() => {
  mockCompaniesOrder.mockResolvedValue({ data: sampleCompanies, error: null })
  mockSkillsOrder.mockResolvedValue({ data: sampleSkills, error: null })
})

describe('useProjectEditorData', () => {
  it('load() populates companies from the companies query result', async () => {
    const { companies, load } = useProjectEditorData()
    await load()
    expect(companies.value).toEqual(sampleCompanies)
  })

  it('load() groups skills by category name', async () => {
    const { skillGroups, load } = useProjectEditorData()
    await load()
    const groupLabels = skillGroups.value.map((group) => group.label)
    expect(groupLabels).toContain('Frontend')
    expect(groupLabels).toContain('Languages')
  })

  it('load() falls back to Uncategorized for skills with null skill_categories', async () => {
    const { skillGroups, load } = useProjectEditorData()
    await load()
    const uncategorized = skillGroups.value.find((group) => group.label === 'Uncategorized')
    expect(uncategorized).toBeDefined()
    expect(uncategorized!.items).toEqual([{ label: 'PostgreSQL', value: 's4' }])
  })

  it('load() sorts groups alphabetically', async () => {
    const { skillGroups, load } = useProjectEditorData()
    await load()
    const groupLabels = skillGroups.value.map((group) => group.label)
    expect(groupLabels).toEqual([...groupLabels].sort((a, b) => a.localeCompare(b)))
  })

  it('load() maps skill name and id correctly into group items', async () => {
    const { skillGroups, load } = useProjectEditorData()
    await load()
    const frontendGroup = skillGroups.value.find((group) => group.label === 'Frontend')
    expect(frontendGroup!.items).toEqual(
      expect.arrayContaining([
        { label: 'Vue', value: 's2' },
        { label: 'Nuxt', value: 's3' },
      ]),
    )
  })

  it('companies and skillGroups start empty before load() is called', () => {
    const { companies, skillGroups } = useProjectEditorData()
    expect(companies.value).toEqual([])
    expect(skillGroups.value).toEqual([])
  })
})
