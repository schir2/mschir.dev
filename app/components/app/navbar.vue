<script setup lang="ts">
const user = useSupabaseUser()
const router = useRouter()
const supabase = useSupabaseClient()

const items = ref([
  {label: 'Home', route: '/'},
  {label: 'Portfolio', route: '/portfolio'},
  {label: 'About', route: '/about'},
  {label: 'Blog', route: '/blog'},
  {label: 'Contact', route: '/contact'}
])

function onLogout() {
  supabase.auth.signOut().then(() => router.push('/'))
}


</script>
<template>

  <p-menubar :model="items">
    <template #start>
      <router-link to="/">
        <div class="flex gap-2 items-center">
          <img src="/img/logos/logo.gif" alt="Logo" class="h-8"/>
        </div>
      </router-link>
    </template>
    <template #item="{item, props, hasSubmenu}">
      <router-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom>
        <a v-ripple :href="href" v-bind="props.action" @click="navigate">
          <span>{{ item.label }}</span>
        </a>
      </router-link>
      <a v-else v-ripple :href="item.url" :target="item.target" v-bind="props.action">
        <span :class="item.icon"/>
        <span>{{ item.label }}</span>
        <span v-if="hasSubmenu" class="pi pi-fw pi-angle-down"/>
      </a>
    </template>
    <template #end>
      <client-only>
        <div class="flex items-center gap-2">
          <p-button icon="pi pi-question" severity="secondary" variant="outlined" rounded @click="router.push('/docs')">
          </p-button>
        </div>
      </client-only>
    </template>
  </p-menubar>
</template>