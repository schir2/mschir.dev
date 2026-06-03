<script setup lang="ts">
import type { MenuItem } from "primevue/menuitem";
import { toMenuItems } from '~/config/adminSections'

const user = useSupabaseUser()
const router = useRouter()
const supabase = useSupabaseClient()

const isAdmin = computed(() => user.value?.app_metadata?.role === 'admin')

const navItems = ref<MenuItem[]>([
  { label: 'Portfolio', to: '/portfolio' },
  { label: 'Articles', to: '/articles' },
  { label: 'About', to: '/about' },
  { label: 'Contact', to: '/contact' },
])

const userMenuRef = ref()

const userMenuItems = computed<MenuItem[]>(() => {
  const items: MenuItem[] = []

  if (isAdmin.value) {
    items.push({
      label: 'Admin',
      icon: 'material-symbols:shield',
      items: toMenuItems(),
    })
  }

  items.push({ label: 'Logout', icon: 'material-symbols:logout', command: onLogout })

  return items
})

const userInitial = computed(() => user.value?.email?.[0]?.toUpperCase() ?? '?')

function onLogout() {
  supabase.auth.signOut().then(() => router.push('/'))
}

function toggleUserMenu(event: Event) {
  userMenuRef.value.toggle(event)
}

const scrolled = ref(false)

function handleScroll() {
  scrolled.value = window.scrollY > 10
}

onMounted(() => window.addEventListener('scroll', handleScroll, { passive: true }))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>

<template>
  <nav :class="['sticky top-0 z-50 transition-shadow duration-200', scrolled ? 'shadow-lg' : '']">
    <p-menubar :model="navItems">
      <template #start>
        <router-link to="/">
          <div class="flex gap-2 items-center">
            <img src="/img/logos/logo.gif" alt="Logo" class="h-8"/>
          </div>
        </router-link>
      </template>
      <template #item="{ item, props }">
        <router-link v-if="item.to" v-slot="{ href, navigate }" :to="item.to" custom>
          <a v-ripple :href="href" v-bind="props.action" @click="navigate">
            <span>{{ item.label }}</span>
          </a>
        </router-link>
        <a v-else v-ripple :href="item.url" :target="item.target" v-bind="props.action">
          <icon v-if="item.icon" :name="item.icon"/>
          <span>{{ item.label }}</span>
        </a>
      </template>
      <template #end>
        <div class="flex items-center gap-2">
          <div class="hidden sm:flex items-center gap-2">
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
          </div>
          <client-only>
            <template v-if="user">
              <p-tiered-menu ref="userMenuRef" :model="userMenuItems" popup>
                <template #item="{ item, props: menuProps }">
                  <router-link v-if="item.to" v-slot="{ href, navigate }" :to="item.to" custom>
                    <a v-ripple :href="href" v-bind="menuProps.action" @click="navigate">
                      <icon v-if="item.icon" :name="item.icon" class="mr-2"/>
                      <span>{{ item.label }}</span>
                    </a>
                  </router-link>
                  <a v-else v-ripple v-bind="menuProps.action">
                    <icon v-if="item.icon" :name="item.icon" class="mr-2"/>
                    <span>{{ item.label }}</span>
                  </a>
                </template>
              </p-tiered-menu>
              <p-avatar
                :label="userInitial"
                shape="circle"
                class="cursor-pointer"
                @click="toggleUserMenu"
              />
            </template>
            <p-button v-else text rounded aria-label="Login" @click="router.push('/login')">
              <template #icon>
                <icon name="mdi:account-circle"/>
              </template>
            </p-button>
          </client-only>
        </div>
      </template>
    </p-menubar>
  </nav>
</template>
