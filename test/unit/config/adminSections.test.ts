import { it, expect, describe } from 'vitest'
import { ADMIN_SECTIONS, toSidebarMenuItems } from '../../../app/config/adminSections'

describe('toSidebarMenuItems', () => {
  it('returns one group per AdminGroup', () => {
    const result = toSidebarMenuItems()
    expect(result).toHaveLength(ADMIN_SECTIONS.length)
  })

  it('each group has the label from its AdminGroup', () => {
    const result = toSidebarMenuItems()
    ADMIN_SECTIONS.forEach((group, index) => {
      expect(result[index].label).toBe(group.label)
    })
  })

  it('each group has one item per AdminSection with label, icon, and to', () => {
    const result = toSidebarMenuItems()
    ADMIN_SECTIONS.forEach((group, groupIndex) => {
      const groupItems = result[groupIndex].items ?? []
      expect(groupItems).toHaveLength(group.sections.length)
      group.sections.forEach((section, sectionIndex) => {
        expect(groupItems[sectionIndex]).toMatchObject({
          label: section.label,
          icon: section.icon,
          to: section.to,
        })
      })
    })
  })
})
