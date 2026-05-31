import { it, expect, describe } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'
import CategoryTagFilter from '../../../../app/components/article/CategoryTagFilter.vue'
import type { ArticleCategory, ArticleTag } from '#shared/types/Articles'

const baseCategories: ArticleCategory[] = [
  { id: 'cat-1', name: 'Programming', slug: 'programming', description: null },
  { id: 'cat-2', name: 'Design', slug: 'design', description: 'Design articles' },
]

const baseTags: ArticleTag[] = [
  { id: 'tag-1', name: 'Vue', slug: 'vue' },
  { id: 'tag-2', name: 'TypeScript', slug: 'typescript' },
]

describe('CategoryTagFilter', () => {
  it('renders a chip for each category', async () => {
    const wrapper = await mountSuspended(CategoryTagFilter, {
      props: {
        categories: baseCategories,
        tags: [],
        modelCategory: null,
        modelTags: [],
      },
    })

    expect(wrapper.text()).toContain('Programming')
    expect(wrapper.text()).toContain('Design')
  })

  it('clicking an inactive category chip emits update:modelCategory with that slug', async () => {
    const wrapper = await mountSuspended(CategoryTagFilter, {
      props: {
        categories: baseCategories,
        tags: [],
        modelCategory: null,
        modelTags: [],
      },
    })

    const categoryButtons = wrapper.findAll('button')
    await categoryButtons[0].trigger('click')

    expect(wrapper.emitted('update:modelCategory')).toBeTruthy()
    expect(wrapper.emitted('update:modelCategory')![0]).toEqual(['programming'])
  })

  it('clicking the active category chip emits update:modelCategory with null to deselect', async () => {
    const wrapper = await mountSuspended(CategoryTagFilter, {
      props: {
        categories: baseCategories,
        tags: [],
        modelCategory: 'programming',
        modelTags: [],
      },
    })

    const categoryButtons = wrapper.findAll('button')
    await categoryButtons[0].trigger('click')

    expect(wrapper.emitted('update:modelCategory')).toBeTruthy()
    expect(wrapper.emitted('update:modelCategory')![0]).toEqual([null])
  })

  it('renders a chip for each tag', async () => {
    const wrapper = await mountSuspended(CategoryTagFilter, {
      props: {
        categories: [],
        tags: baseTags,
        modelCategory: null,
        modelTags: [],
      },
    })

    expect(wrapper.text()).toContain('Vue')
    expect(wrapper.text()).toContain('TypeScript')
  })

  it('clicking an inactive tag chip emits update:modelTags with that slug appended', async () => {
    const wrapper = await mountSuspended(CategoryTagFilter, {
      props: {
        categories: [],
        tags: baseTags,
        modelCategory: null,
        modelTags: [],
      },
    })

    const tagButtons = wrapper.findAll('button')
    await tagButtons[0].trigger('click')

    expect(wrapper.emitted('update:modelTags')).toBeTruthy()
    expect(wrapper.emitted('update:modelTags')![0]).toEqual([['vue']])
  })

  it('clicking an active tag chip emits update:modelTags with that slug removed', async () => {
    const wrapper = await mountSuspended(CategoryTagFilter, {
      props: {
        categories: [],
        tags: baseTags,
        modelCategory: null,
        modelTags: ['vue', 'typescript'],
      },
    })

    const tagButtons = wrapper.findAll('button')
    await tagButtons[0].trigger('click')

    expect(wrapper.emitted('update:modelTags')).toBeTruthy()
    expect(wrapper.emitted('update:modelTags')![0]).toEqual([['typescript']])
  })
})
