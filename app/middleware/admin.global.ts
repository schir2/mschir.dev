export default defineNuxtRouteMiddleware((to) => {
  if (!to.path.startsWith('/admin')) return

  const user = useSupabaseUser()

  if (!user.value) {
    return navigateTo('/login')
  }

  if (user.value.app_metadata?.role !== 'admin') {
    return navigateTo('/')
  }
})
