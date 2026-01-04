<script lang="ts" setup>
import {z} from 'zod';
import {zodResolver} from '@primevue/forms/resolvers/zod';
import type {FormSubmitEvent} from "@primevue/forms/form";

const config = useRuntimeConfig()
const toast = useToast()

definePageMeta({
  title: 'Login',
  layout: 'default'
})

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const CredentialsSchema = z.object({
  email: z.string().min(3).email(),
  password: z.string().min(8),
})

const resolver = zodResolver(CredentialsSchema);

type Credentials = z.infer<typeof CredentialsSchema>

const initialValues = reactive<Credentials>({email: '', password: ''});

async function signUp(signUpCredentials: Credentials) {
  const {error, data} = await supabase.auth.signUp(signUpCredentials)
  if (error) {
    toast.add({
      severity: 'error',
      summary: 'Registration Failed',
      detail: error.message
    })
  }
  else {
    console.log(data)
  }
}

async function onFormSubmit(event: FormSubmitEvent) {
  if (event.valid) {
    await signUp(event.values as Credentials);
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
    <p-card v-if="user" title="Logout">
      <template #content>
        <p-button label="Logout" icon="pi pi-logout"></p-button>
      </template>
    </p-card>
    <p-card v-else>
      <template #title>Login to mschir.dev</template>
      <template #content>
        <p-form
            v-slot="$form"
            :resolver
            :initialValues
            @submit="onFormSubmit"
            class="flex flex-col gap-4 w-full"
        >
          <div class="flex flex-col gap-1">
            <p-input-text name="email" type="text" placeholder="Email" fluid/>
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
          <p-button type="submit" severity="success" icon="pi pi-user-plus" label="Register"/>
          <p-button fluid variant="text" severity="danger" label="Use Google" icon="pi pi-google"
                    @click="onLoginWithGoogle"/>
          <p class="text-center">
            Already Signed Up? <nuxt-link class="text-primary" to="/login">Login</nuxt-link>
          </p>
        </p-form>
      </template>
    </p-card>
  </div>
</template>