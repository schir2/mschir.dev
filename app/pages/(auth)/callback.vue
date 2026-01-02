<script lang="ts" setup>
const {userProfile, load} = useUserProfileService()
onMounted(async () => {
  await load()
  if (!userProfile?.value) {
    navigateTo('/create_profile')
  } else {
    navigateTo('/dashboard')
  }
})
</script>
<template>
  {{ userProfile }}
  <h1>Callback</h1>
</template>