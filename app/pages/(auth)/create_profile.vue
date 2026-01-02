<script lang="ts" setup>
import {zodResolver} from '@primevue/forms/resolvers/zod';
import {type UserProfileInsertData, UserProfileInsertSchema} from "~/schemas/user_profile_schema";
import type {FormSubmitEvent} from "~/types/FormSubmitEvent";

const user = useSupabaseUser()
const {handleUploadAvatar, createUserProfile} = useUserProfileService()
const router = useRouter()

let initialValues = ref<UserProfileInsertData | null>(null)
const resolver = zodResolver(UserProfileInsertSchema)
const loading = ref<boolean>(false);

async function onFormSubmit({valid, values}: FormSubmitEvent<UserProfileInsertData>) {
  loading.value = true;
  if (valid) {
    await createUserProfile(values)
    if (useExistingAvatar.value && user?.value?.user_metadata?.avatar_url) {
      const response = await fetch(user.value.user_metadata.avatar_url)
      const blob = await response.blob()
      const file = new File([blob], 'avatar.jpg', {type: blob.type})
      await handleUploadAvatar(user.value.id, file)
    }
  }
  loading.value = false;
  await router.push('/dashboard')
}

onMounted(async () => {
      if (user?.value?.user_metadata) {
        const user_metadata = user.value.user_metadata
        const name_parts = user_metadata.full_name.split(' ')
        initialValues.value = {
          id: user.value.id,
          email: user.value.email ?? '',
          first_name: name_parts.length > 0 ? name_parts[0] : '',
          last_name: name_parts.length > 1 ? name_parts[1] : '',
          display_name: user_metadata.email ? user_metadata.email.split('@')[0] : '',
        }
      }
    }
)

function getInitials(formData) {
  if (formData) {
    let initials = ''
    if (formData.first_name?.value) {
      initials += formData.first_name.value[0]
    }
    if (formData.last_name?.value) {
      initials += formData.last_name.value[0]
    }
    return initials
  }
}

const useExistingAvatar = ref<boolean>(true)

</script>
<template>
  <p-form
      v-if="initialValues"
      v-slot="$form"
      :resolver="resolver"
      :initialValues="initialValues"
      @submit="onFormSubmit"
      class="space-y-2 max-w-lg mx-auto"
  >
    <p-card>
      <template #header>
        <h1 class="text-2xl font-semibold mt-8 mb-2 text-center">Create Your Profile</h1>
        <h2 class="text font-light text-center">Welcome! Let’s complete your profile to get started.</h2>
      </template>
      <template #content>
        <p-input-text hidden name="id"/>
        <p-input-text hidden id="default_workspace_id" name="default_workspace_id"/>
        <p-input-text hidden id="avatar_url" name="avatar_url"/>

        <div class="space-y-4">
          <p-card>
            <template #subtitle>
              <p class="text-center mb-2">
                Choose your profile look —
                <span class="block mt-1 text-sm">
              Stick with your imported photo, or go minimalist with your initials.
              Either way, it’s all you ✨
            </span>
              </p>
            </template>
            <template #content>

              <div class="text-center mb-4">
                <p-avatar
                    v-if="user?.user_metadata?.avatar_url"
                    :image="user.user_metadata.avatar_url"
                    shape="circle"
                    size="xlarge"
                    v-ripple
                    @click="useExistingAvatar = true"
                    :class="useExistingAvatar ? 'ring-2 ring-primary' : ''"

                />
                <p-avatar
                    :label=getInitials($form)
                    shape="circle"
                    size="xlarge"
                    v-ripple
                    @click="useExistingAvatar = false"
                    :class="!useExistingAvatar ? 'ring-2 ring-primary' : ''"

                />

              </div>
            </template>
          </p-card>

          <div class="flex flex-col gap-1">
            <p-float-label variant="on">
              <p-input-text
                  fluid
                  id="email"
                  name="email"
                  disabled
              />
              <label for="email">Email</label>
            </p-float-label>
            <p-message
                v-if="$form.email?.invalid"
                severity="error"
                size="small"
                variant="simple"
            >
              {{ $form.email.error.message }}
            </p-message>
            <em class="text-sm mx-2">We’ll use this for invites and updates — it’s locked in.</em>
          </div>

          <div class="flex flex-col gap-1">
            <p-float-label variant="on">
              <p-input-text fluid id="first_name" name="first_name"/>
              <label for="first_name">First Name (or alias)</label>
            </p-float-label>
            <p-message
                v-if="$form.first_name?.invalid"
                severity="error"
                size="small"
                variant="simple"
            >
              {{ $form.first_name.error.message }}
            </p-message>
            <em class="text-sm mx-2">Just something cool we can use if you don’t upload a pic</em>
          </div>

          <div class="flex flex-col gap-1">
            <p-float-label variant="on">
              <p-input-text fluid id="last_name" name="last_name"/>
              <label for="last_name">Last Name (or whatever)</label>
            </p-float-label>
            <em class="text-sm mx-2">Or skip it &mdash; we're not checking IDs</em>
            <p-message
                v-if="$form.last_name?.invalid"
                severity="error"
                size="small"
                variant="simple"
            >
              {{ $form.last_name.error.message }}
            </p-message>
          </div>

          <div class="flex flex-col gap-1">
            <p-float-label variant="on">
              <p-input-text variant="outlined" fluid id="display_name" name="display_name"/>
              <label for="display_name">Display Name</label>
            </p-float-label>
            <em class="text-sm mx-2">This is the name others will see</em>
            <p-message
                v-if="$form.display_name?.invalid"
                severity="error"
                size="small"
                variant="simple"
            >
              {{ $form.display_name.error.message }}
            </p-message>
          </div>
        </div>
      </template>
      <template #footer>
        <div class="text-center">
          <p class="text-xs text-muted-foreground text-center mt-4">
            We don’t use your profile info for anything else — just to personalize your experience.
          </p>
          <p-button class="mt-4 mb-1" type="submit" icon="pi pi-check-circle"
                    label="Looks good &mdash; Lets Go!"/>
        </div>
      </template>
    </p-card>
  </p-form>
</template>
<style scoped>
</style>