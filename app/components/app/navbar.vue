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
      <p>Marek Schir, Software Engineer</p>
    </template>
    <template #center>
      <p-button label="Home" severity="secondary" @click="router.push('/homw')" text/>
      <p-button label="Portfolio" severity="secondary" @click="router.push('/portfolio')" text/>
      <p-button label="About" severity="secondary" @click="router.push('/about')" text/>
      <p-button label="Blog" severity="secondary" @click="router.push('/blog')" text/>
      <p-button label="Get in Touch" severity="secondary" @click="router.push('/contact')" text/>
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