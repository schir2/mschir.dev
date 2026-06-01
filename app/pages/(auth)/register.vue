<script lang="ts" setup>
import type {FormSubmitEvent} from "@primevue/forms/form";
import {zodResolver} from '@primevue/forms/resolvers/zod'
import {CredentialsSchema} from '~/schemas/CredentialsSchema'
import type {Credentials} from '~/types/Credentials'

const toast = useToast()

definePageMeta({
  title: 'Register',
  layout: 'default'
})

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const resolver = zodResolver(CredentialsSchema);

const initialValues = reactive<Credentials>({email: '', password: ''});

async function signUp(signUpCredentials: Credentials) {
  const {error} = await supabase.auth.signUp(signUpCredentials)
  if (error) {
    toast.add({
      severity: 'error',
      summary: 'Registration Failed',
      detail: error.message
    })
  }

}

async function onFormSubmit(event: FormSubmitEvent) {
  if (event.valid) {
    await signUp(event.values as Credentials);
  }
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
      <template #title>Create an Account</template>
      <template #content>
        <p-form
            v-slot="$form"
            :resolver="resolver"
            :initialValues="initialValues"
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
            Already Signed Up?
            <nuxt-link class="text-primary" to="/login">Login</nuxt-link>
          </p>
        </p-form>
      </template>
    </p-card>
  </div>
</template>