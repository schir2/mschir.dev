type Company = { id: string; name: string }
type SkillWithCategory = { id: string; name: string; skill_categories: { name: string } | null }
type SkillGroupOption = { label: string; items: { label: string; value: string }[] }

export function useProjectEditorData() {
  const supabase = useSupabaseClient()
  const companies = ref<Company[]>([])
  const skillGroups = ref<SkillGroupOption[]>([])

  async function load(): Promise<void> {
    const [companiesResult, skillsResult] = await Promise.all([
      supabase.from('companies').select('id, name').order('name'),
      supabase.from('skills').select('id, name, skill_categories(name)').order('name'),
    ])

    if (companiesResult.data) companies.value = companiesResult.data as Company[]

    if (skillsResult.data) {
      const groupMap = new Map<string, { label: string; value: string }[]>()
      for (const skill of skillsResult.data as SkillWithCategory[]) {
        const categoryName = skill.skill_categories?.name ?? 'Uncategorized'
        if (!groupMap.has(categoryName)) groupMap.set(categoryName, [])
        groupMap.get(categoryName)!.push({ label: skill.name, value: skill.id })
      }
      skillGroups.value = Array.from(groupMap.entries())
        .sort(([nameA], [nameB]) => nameA.localeCompare(nameB))
        .map(([label, items]) => ({ label, items }))
    }
  }

  return { companies, skillGroups, load }
}
