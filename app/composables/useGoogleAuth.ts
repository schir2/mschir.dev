export async function onLoginWithGoogle() {
  const config = useRuntimeConfig()
  const supabase = useSupabaseClient()
  await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: `${config.public.siteUrl}/callback`,
    },
  })
}
