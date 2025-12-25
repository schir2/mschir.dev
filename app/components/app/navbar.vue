<script setup lang="ts">
const user = useSupabaseUser()
const router = useRouter()
const supabase = useSupabaseClient()

function onLogout() {
  supabase.auth.signOut().then(() => router.push('/'))
}


</script>
<template>

  <p-toolbar>
    <template #start>
      <router-link to="/">
        <img src="/img/logos/logo.gif" alt="Logo" class="h-8"/>
      </router-link>
      <p-button label="Dashboard" severity="secondary" @click="router.push('/dashboard')" text/>
      <p-button label="Features" severity="secondary" @click="router.push('/features')" text/>
    </template>
    <template #center>
    </template>
    <template #end>
      <client-only>
        <div class="flex items-center gap-2">
          <p-button icon="pi pi-question" severity="secondary" variant="outlined" rounded @click="router.push('/docs')">
          </p-button>
        </div>
      </client-only>
    </template>
  </p-toolbar>
</template>