import type { MenuItem } from 'primevue/menuitem'

interface AdminSection {
  label: string
  singular: string
  to: string
  icon: string
  description: string
  getPublicUrl?: (row: Record<string, unknown>) => string
}

interface AdminGroup {
  label: string
  sections: AdminSection[]
}

export const ADMIN_SECTIONS = [
  {
    label: 'Content',
    sections: [
      {
        label: 'Articles',
        singular: 'Article',
        to: '/admin/articles',
        icon: 'material-symbols:article',
        description: 'Manage blog articles and drafts',
        getPublicUrl: (row: Record<string, unknown>) => `/articles/${row.slug}`,
      },
      {
        label: 'Categories',
        singular: 'Category',
        to: '/admin/categories',
        icon: 'material-symbols:category',
        description: 'Manage article categories',
      },
      {
        label: 'Series',
        singular: 'Series',
        to: '/admin/series',
        icon: 'material-symbols:format-list-bulleted',
        description: 'Manage article series',
      },
    ],
  },
  {
    label: 'Portfolio',
    sections: [
      {
        label: 'Projects',
        singular: 'Project',
        to: '/admin/projects',
        icon: 'material-symbols:work',
        description: 'Manage portfolio projects',
        getPublicUrl: (row: Record<string, unknown>) => `/projects/${row.slug}`,
      },
      {
        label: 'Companies',
        singular: 'Company',
        to: '/admin/companies',
        icon: 'material-symbols:corporate-fare',
        description: 'Manage companies associated with projects',
      },
      {
        label: 'Skills',
        singular: 'Skill',
        to: '/admin/skills',
        icon: 'material-symbols:construction',
        description: 'Manage skills and technologies',
      },
    ],
  },
  {
    label: 'Inbox',
    sections: [
      {
        label: 'Contact Messages',
        singular: 'Contact Message',
        to: '/admin/contact-messages',
        icon: 'material-symbols:mail',
        description: 'View and manage incoming contact messages',
      },
    ],
  },
] satisfies AdminGroup[]

export function toMenuItems(): MenuItem[] {
  return ADMIN_SECTIONS.flatMap((group: AdminGroup) =>
    group.sections.map((section: AdminSection): MenuItem => ({
      label: section.label,
      to: section.to,
      icon: section.icon,
    }))
  )
}
