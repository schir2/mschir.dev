<script lang="ts" setup>
import {z} from 'zod'
import {zodResolver} from '@primevue/forms/resolvers/zod'
import type {FormSubmitEvent} from '@primevue/forms/form'

import type {ContactReason} from "#shared/types/ContactReason";

definePageMeta({title: 'Contact'})

const supabase = useSupabaseClient()
const toast = useToast()

const {data: reasons} = await useAsyncData<ContactReason[]>(
    'contact-reasons',
    async () => {
      const {data} = await supabase
          .from('contact_reasons')
          .select('id, label, order')
          .order('order')
      return data ?? []
    },
    {lazy: true}
)

const ContactSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters').max(100),
  email: z.string().email('Please enter a valid email address'),
  reason_id: z.string().min(1, 'Please select a reason for reaching out'),
  message: z.string().min(0, 'Message must be at least 10 characters').max(2000),
} satisfies { [K in keyof ContactMessageInsert]: z.ZodTypeAny })

const initialValues = reactive({name: '', email: '', reason_id: '', message: ''})
const resolver = zodResolver(ContactSchema)
const turnstileToken = ref('')
const pending = ref(false)
const submitted = ref(false)

async function onFormSubmit(event: FormSubmitEvent) {
  if (!event.valid) return
  if (!turnstileToken.value) {
    toast.add({severity: 'warn', summary: 'Please complete the CAPTCHA', life: 4000})
    return
  }
  pending.value = true

  const {data, error} = await supabase.from('contact_messages').insert(event.values)

  if (error) {

    toast.add({severity: 'error', summary: 'Something went wrong', detail: 'Please try again later.', life: 5000})
  }
  pending.value = false
}
</script>

<template>
  <section class="max-w-6xl mx-auto px-6 py-16">

    <!-- Confirmation state -->
    <div v-if="submitted" class="flex flex-col items-center justify-center py-24 gap-6 text-center">
      <icon name="material-symbols:check-circle" class="text-green-400 text-6xl"/>
      <h2 class="text-3xl font-bold">Message sent</h2>
      <p class="text-surface-400 max-w-md">
        Thanks for reaching out. I'll get back to you as soon as I can.
      </p>
    </div>

    <!-- Form state -->
    <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-16 items-start">

      <!-- Left: pitch -->
      <div class="flex flex-col gap-6">
        <div>
          <h1 class="text-4xl font-bold mb-4">Get in Touch</h1>
          <p class="text-surface-300 text-lg leading-relaxed">
            Whether you're looking to hire, explore a contracting opportunity, or have a
            question about one of my articles — I'd love to hear from you.
          </p>
        </div>
        <ul class="flex flex-col gap-3">
          <li class="flex items-center gap-3 text-surface-300">
            <icon name="material-symbols:work" class="text-primary"/>
            Full-time engineering roles
          </li>
          <li class="flex items-center gap-3 text-surface-300">
            <icon name="material-symbols:code" class="text-primary"/>
            Contract &amp; freelance projects
          </li>
          <li class="flex items-center gap-3 text-surface-300">
            <icon name="material-symbols:menu-book" class="text-primary"/>
            Questions about my articles
          </li>
        </ul>
      </div>

      <!-- Right: form -->
      <p-form
          v-slot="$form"
          :resolver
          :initialValues
          @submit="onFormSubmit"
          class="flex flex-col gap-5"
      >
        <div class="flex flex-col gap-1">
          <label class="text-sm font-medium">Name</label>
          <p-input-text name="name" placeholder="Your name" fluid/>
          <p-message v-if="$form.name?.invalid" severity="error" size="small" variant="simple">
            {{ $form.name.error?.message }}
          </p-message>
        </div>

        <div class="flex flex-col gap-1">
          <label class="text-sm font-medium">Email</label>
          <p-input-text name="email" type="email" placeholder="you@example.com" fluid/>
          <p-message v-if="$form.email?.invalid" severity="error" size="small" variant="simple">
            {{ $form.email.error?.message }}
          </p-message>
        </div>

        <div class="flex flex-col gap-1">
          <label class="text-sm font-medium">Reason</label>
          <p-select
              name="reason_id"
              :options="reasons ?? []"
              option-label="label"
              option-value="id"
              placeholder="Select a reason"
              fluid
          />
          <p-message v-if="$form.reason_id?.invalid" severity="error" size="small" variant="simple">
            {{ $form.reason_id.error?.message }}
          </p-message>
        </div>

        <div class="flex flex-col gap-1">
          <label class="text-sm font-medium">Message</label>
          <p-textarea name="message" placeholder="Tell me what's on your mind..." rows="6" fluid/>
          <p-message v-if="$form.message?.invalid" severity="error" size="small" variant="simple">
            {{ $form.message.error?.message }}
          </p-message>
        </div>

        <turnstile-placeholder v-model="turnstileToken"/>

        <p-button type="submit" label="Send Message" :loading="pending" fluid>
          <template #icon>
            <icon name="material-symbols:send"/>
          </template>
        </p-button>
      </p-form>
    </div>
  </section>
</template>