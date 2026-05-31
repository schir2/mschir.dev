import { it, expect, describe } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'
import SkillsSnapshot from '../../../../app/components/portfolio/SkillsSnapshot.vue'

const skills = [
  { id: '1', name: 'Python', icon: 'simple-icons:python' },
  { id: '2', name: 'Django', icon: 'simple-icons:django' },
  { id: '3', name: 'VUE', icon: 'simple-icons:vuedotjs' },
]

describe('SkillsSnapshot', () => {
  it('renders one label per skill', async () => {
    const wrapper = await mountSuspended(SkillsSnapshot, { props: { skills } })
    const labels = wrapper.findAll('span')
    const names = labels.map(label => label.text())
    expect(names).toContain('Python')
    expect(names).toContain('Django')
    expect(names).toContain('VUE')
  })

  it('renders nothing when skills list is empty', async () => {
    const wrapper = await mountSuspended(SkillsSnapshot, { props: { skills: [] } })
    expect(wrapper.find('div').exists()).toBe(false)
  })
})
