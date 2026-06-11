<script lang="ts" setup>
const currentYear = new Date().getFullYear()
const { isModalActive } = useCookieControl()

const navLinks = [
  { label: 'Portfolio', route: '/portfolio' },
  { label: 'Services', route: '/services' },
  { label: 'Articles', route: '/articles' },
  { label: 'About', route: '/about' },
  { label: 'Contact', route: '/contact' },
]
</script>

<template>
  <footer class="dark-mode bg-surface-900 text-color border-t border-surface-700">
    <div class="max-w-6xl mx-auto px-6 py-12 flex flex-col gap-10">

      <div class="grid grid-cols-1 md:grid-cols-3 gap-10">

        <div class="flex flex-col gap-3">
          <nuxt-link to="/" class="flex items-center gap-2">
            <img src="/img/logos/logo.gif" alt="Logo" class="h-8"/>
            <span class="font-semibold text-lg">Marek Schir</span>
          </nuxt-link>
          <p class="text-sm text-muted-color">
            Software and integrations for growing businesses.
          </p>
        </div>

        <div class="flex flex-col gap-3">
          <span class="text-xs font-semibold uppercase tracking-widest text-muted-color">Navigation</span>
          <nav class="grid grid-cols-2 gap-2">
            <nuxt-link
                v-for="link in navLinks"
                :key="link.route"
                :to="link.route"
                class="text-sm text-surface-300 transition-colors hover:text-color"
                active-class="text-primary"
            >
              {{ link.label }}
            </nuxt-link>
          </nav>
        </div>

        <div class="flex flex-col gap-3">
          <span class="text-xs font-semibold uppercase tracking-widest text-muted-color">Connect</span>
          <div class="flex gap-1">
            <a href="https://github.com/schir2" target="_blank" rel="noopener noreferrer" aria-label="GitHub"
               class="inline-flex p-1.5 rounded-full text-muted-color transition-colors hover:bg-surface-700 hover:text-color">
              <icon name="mdi:github" class="text-2xl"/>
            </a>
            <a href="https://www.linkedin.com/in/marek-schir-95229684/" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn"
               class="inline-flex p-1.5 rounded-full text-muted-color transition-colors hover:bg-surface-700 hover:text-color">
              <icon name="mdi:linkedin" class="text-2xl"/>
            </a>
            <nuxt-link to="/contact" aria-label="Get in Touch"
               class="inline-flex p-1.5 rounded-full text-muted-color transition-colors hover:bg-surface-700 hover:text-color">
              <icon name="material-symbols:mail" class="text-2xl"/>
            </nuxt-link>
          </div>
        </div>

      </div>

      <div class="pt-6 border-t border-surface-700 flex items-center justify-between gap-4">
        <span class="text-sm text-muted-color">
          &copy; {{ currentYear }} Marek Schir
        </span>
        <p-button label="Cookie Preferences" text severity="secondary" size="small" @click="isModalActive = true" />
      </div>

    </div>
  </footer>
</template>