<script lang="ts" setup>
import {z} from "zod";
import {zodResolver} from "@primevue/forms/resolvers/zod";
import type {FormSubmitEvent} from "@primevue/forms/form";

const supabase = useSupabaseClient()
const toast = useToast()

const CredentialsSchema = z.object({
  email: z.string().min(3).email(),
  password: z.string().min(8),
})
type Credentials = z.infer<typeof CredentialsSchema>

const initialValues = reactive<Credentials>({email: '', password: ''});
const resolver = zodResolver(CredentialsSchema);

async function onFormSubmit(event: FormSubmitEvent) {
  if (event.valid) {
    await signUp(event.values as Credentials);
  }
}

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

</script>
<template>
  <p-form
      v-slot="$form"
      :resolver
      :initialValues
      @submit="onFormSubmit"
      class="flex flex-col gap-4 w-full"
  >
    <div class="flex flex-col gap-1">
      <p-input-text name="email" type="text" placeholder="email" fluid/>
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
    <p-button type="submit" icon="pi pi-sign-in" label="Register"/>
  </p-form>
</template>