<script lang="ts" setup>
definePageMeta({
  layout: 'default',
})

const user = useSupabaseUser()
const session = useSupabaseSession()
const router = useRouter()
const route = useRoute()

watchEffect(() => {
  if (user.value) {
    router.replace('/')
  }
})

onMounted(() => {
  const oauthError = route.query.error as string | undefined
  const oauthErrorDescription = route.query.error_description as string | undefined

  if (oauthError) {
    const message = oauthError === 'access_denied'
      ? 'Google sign-in was cancelled.'
      : (oauthErrorDescription ?? 'Sign-in failed. Please try again.')
    router.replace(`/login?error=${encodeURIComponent(message)}`)
    return
  }

  if (!session.value) {
    router.replace(`/login?error=${encodeURIComponent('Sign-in failed. The link may have expired — please try again.')}`)
  }
})
</script>

<template>
  <div class="flex flex-col gap-4 items-center justify-center min-h-nav-offset">
    <p-progress-spinner />
    <p class="text-muted-color">Signing you in…</p>
  </div>
</template>
