import { it, expect, describe } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'
import FeaturedProjectCard from '../../../../app/components/portfolio/FeaturedProjectCard.vue'
import type { FeaturedProject } from '#shared/types/Projects'

const baseFeaturedProject: FeaturedProject = {
  id: 'fp-1',
  project_id: 'p-1',
  tagline: 'A punchy portfolio tagline.',
  display_order: 1,
  created_at: '2026-01-01T00:00:00Z',
  updated_at: '2026-01-01T00:00:00Z',
  projects: {
    name: 'Customer Quoting App',
    description: 'Internal quoting tool.',
    image_url: null,
    year: 2024,
    project_skills: [
      { skills: { id: 's-1', name: 'Python', icon: 'simple-icons:python' } },
      { skills: { id: 's-2', name: 'Django', icon: 'simple-icons:django' } },
    ],
  },
}

describe('FeaturedProjectCard', () => {
  it('renders the project name', async () => {
    const wrapper = await mountSuspended(FeaturedProjectCard, {
      props: { featuredProject: baseFeaturedProject },
    })
    expect(wrapper.text()).toContain('Customer Quoting App')
  })

  it('renders the tagline', async () => {
    const wrapper = await mountSuspended(FeaturedProjectCard, {
      props: { featuredProject: baseFeaturedProject },
    })
    expect(wrapper.text()).toContain('A punchy portfolio tagline.')
  })

  it('renders one chip per skill', async () => {
    const wrapper = await mountSuspended(FeaturedProjectCard, {
      props: { featuredProject: baseFeaturedProject },
    })
    expect(wrapper.text()).toContain('Python')
    expect(wrapper.text()).toContain('Django')
  })

  it('does not render an image when image_url is null', async () => {
    const wrapper = await mountSuspended(FeaturedProjectCard, {
      props: { featuredProject: baseFeaturedProject },
    })
    expect(wrapper.find('img').exists()).toBe(false)
  })

  it('renders an image when image_url is present', async () => {
    const withImage: FeaturedProject = {
      ...baseFeaturedProject,
      projects: { ...baseFeaturedProject.projects, image_url: 'https://example.com/img.png' },
    }
    const wrapper = await mountSuspended(FeaturedProjectCard, {
      props: { featuredProject: withImage },
    })
    expect(wrapper.find('img').attributes('src')).toBe('https://example.com/img.png')
  })
})
