<script lang="ts" setup>
import {z} from 'zod';
import {zodResolver} from '@primevue/forms/resolvers/zod';

const config = useRuntimeConfig()

definePageMeta({
  title: 'Login',
  layout: 'default'
})

const supabase = useSupabaseClient()

const CredentialsSchema = z.object({
  email: z.string().min(3).email(),
  password: z.string().min(8),
})

const resolver = zodResolver(CredentialsSchema);

type Credentials = z.infer<typeof CredentialsSchema>

const initialValues = reactive<Credentials>({email: '', password: ''});

const signIn = async (credentials: Credentials) => {
  const {error} = await supabase.auth.signInWithPassword({
    email: credentials.email,
    password: credentials.password,
  })
  if (error) throw new Error(`Login Failed ${error}`)
}

async function onFormSubmit(event) {
  if (event.valid) {
    await signIn(event.values)
  }
}

async function onLoginWithGoogle() {
  await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: `${config.public.siteUrl}`,
    }
  }).finally(async () => {
    console.log('done')
  })
}
</script>
<template>
  <div class="flex flex-col gap-4 justify-center items-center min-h-nav-offset">
    <div class="max-w-80">
      <h1 class="text-4xl font-semibold text-center">Welcome to Arcus</h1>
      <h2 class="text-xl font-light text-center mb-8">To get Started, please sign in</h2>
      <p-form
          v-slot="$form"
          :resolver
          :initialValues
          @submit="onFormSubmit"
          class="flex flex-col gap-4 w-full"
      >
        <div class="flex flex-col gap-1">
          <p-input-text name="email" type="text" placeholder="username" fluid/>
          <p-message v-if="$form.email?.invalid" severity="error" size="small" variant="simple">{{
              $form.email.error.message
            }}
          </p-message>
        </div>
        <div class="flex flex-col gap-1">
          <p-password name="password" placeholder="Password" :feedback="false" toggleMask fluid/>
          <p-message v-if="$form.password?.invalid" severity="error" size="small" variant="simple">
            <ul class="my-0 px-4 flex flex-col gap-1">
              <li v-for="(error, index) of $form.password.errors" :key="index">{{ error.message }}</li>
            </ul>
          </p-message>
        </div>
        <p-button type="submit" icon="pi pi-sign-in" label="Login"/>
        <p-button variant="outlined" severity="secondary" label="Login with Google" icon="pi pi-google"
                  @click="onLoginWithGoogle"/>
      </p-form>
    </div>
  </div>
</template>