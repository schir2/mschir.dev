<script setup lang="ts">
import type {MenuItem} from "primevue/menuitem";

const user = useSupabaseUser()
const router = useRouter()
const supabase = useSupabaseClient()

const items = ref<MenuItem[]>([
  {label: 'Home', route: '/'},
  {label: 'Portfolio', route: '/portfolio'},
  {label: 'About', route: '/about'},
  {label: 'Articles', route: '/articles'},
  {label: 'Contact', route: '/contact'},
  {label: 'Projects', route: '/projects'}
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
      <div class="flex items-center gap-2">
        <a href="https://github.com/schir2" target="_blank" rel="noopener noreferrer">
          <p-button text rounded aria-label="GitHub">
            <template #icon>
              <icon name="mdi:github"/>
            </template>
          </p-button>
        </a>
        <a href="https://www.linkedin.com/in/marek-schir-95229684/" target="_blank" rel="noopener noreferrer">
          <p-button text rounded aria-label="LinkedIn">
            <template #icon>
              <icon name="mdi:linkedin"/>
            </template>
          </p-button>
        </a>
        <client-only>
          <p-button v-if="user" label="Logout" @click="onLogout"></p-button>
          <p-button v-else label="Login" severity="secondary" @click="router.push('/login')"/>
        </client-only>
      </div>
    </template>
  </p-menubar>
</template>