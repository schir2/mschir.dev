import { describe, it, expect, vi, beforeEach } from 'vitest'
import { nextTick, ref } from 'vue'
import { mountSuspended, mockNuxtImport } from '@nuxt/test-utils/runtime'
import Navbar from '../../../../app/components/layout/navbar.vue'

const mockSignOut = vi.fn().mockResolvedValue({})
const mockUser = ref<null | { email: string; app_metadata?: { role?: string } }>(null)

mockNuxtImport('useSupabaseUser', () => () => mockUser)
mockNuxtImport('useSupabaseClient', () => () => ({ auth: { signOut: mockSignOut } }))

describe('Navbar', () => {
  beforeEach(() => {
    mockUser.value = null
    mockSignOut.mockClear()
  })

  it('renders four nav items: Portfolio, Articles, About, Contact', async () => {
    const wrapper = await mountSuspended(Navbar)
    const text = wrapper.text()
    expect(text).toContain('Portfolio')
    expect(text).toContain('Articles')
    expect(text).toContain('About')
    expect(text).toContain('Contact')
  })

  it('renders the icon-only login button when unauthenticated', async () => {
    const wrapper = await mountSuspended(Navbar)
    expect(wrapper.find('[aria-label="Login"]').exists()).toBe(true)
  })

  describe('when authenticated', () => {
    beforeEach(() => {
      mockUser.value = { email: 'user@example.com', app_metadata: {} }
    })

    it('renders avatar with uppercased first character of email', async () => {
      const wrapper = await mountSuspended(Navbar)
      expect(wrapper.find('.p-avatar').text()).toBe('U')
    })

    it('does not show Admin Articles in the user menu for a non-admin', async () => {
      const wrapper = await mountSuspended(Navbar)
      await wrapper.find('.p-avatar').trigger('click')
      await nextTick()
      expect(document.body.textContent).not.toContain('Admin Articles')
    })

    describe('as admin', () => {
      beforeEach(() => {
        mockUser.value = { email: 'admin@example.com', app_metadata: { role: 'admin' } }
      })

      it('shows Admin Articles in the user menu', async () => {
        const wrapper = await mountSuspended(Navbar)
        await wrapper.find('.p-avatar').trigger('click')
        await nextTick()
        expect(document.body.textContent).toContain('Admin Articles')
      })
    })

    it('calls signOut and navigates to / when Logout is clicked', async () => {
      const wrapper = await mountSuspended(Navbar)
      await wrapper.find('.p-avatar').trigger('click')
      await nextTick()

      const logoutLink = [...document.body.querySelectorAll('a')].find(anchor =>
        anchor.textContent?.includes('Logout'),
      )
      logoutLink?.dispatchEvent(new MouseEvent('click', { bubbles: true }))
      await nextTick()

      expect(mockSignOut).toHaveBeenCalledOnce()
    })
  })
})
