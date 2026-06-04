<script lang="ts" setup>
const currentYear = new Date().getFullYear()

const navLinks = [
  { label: 'Portfolio', route: '/portfolio' },
  { label: 'Articles', route: '/articles' },
  { label: 'About', route: '/about' },
  { label: 'Contact', route: '/contact' },
]
</script>

<template>
  <footer class="footer-bg border-t border-surface-700 mt-16">
    <div class="max-w-6xl mx-auto px-6 py-12 flex flex-col gap-10">

      <div class="grid grid-cols-1 md:grid-cols-3 gap-10">

        <div class="flex flex-col gap-3">
          <router-link to="/" class="flex items-center gap-2">
            <img src="/img/logos/logo.gif" alt="Logo" class="h-8"/>
            <span class="font-semibold text-lg">Marek Schir</span>
          </router-link>
          <p class="text-sm footer-tagline">
            Software and integrations for growing businesses.
          </p>
        </div>

        <div class="flex flex-col gap-3">
          <span class="text-xs font-semibold uppercase tracking-widest footer-section-label">Navigation</span>
          <nav class="grid grid-cols-2 gap-2">
            <router-link
                v-for="link in navLinks"
                :key="link.route"
                :to="link.route"
                class="text-sm transition-colors footer-nav-link"
                active-class="text-primary"
            >
              {{ link.label }}
            </router-link>
          </nav>
        </div>

        <div class="flex flex-col gap-3">
          <span class="text-xs font-semibold uppercase tracking-widest footer-section-label">Connect</span>
          <div class="flex gap-1">
            <a href="https://github.com/schir2" target="_blank" rel="noopener noreferrer" aria-label="GitHub" class="social-icon-link">
              <icon name="mdi:github" class="text-2xl"/>
            </a>
            <a href="https://www.linkedin.com/in/marek-schir-95229684/" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn" class="social-icon-link">
              <icon name="mdi:linkedin" class="text-2xl"/>
            </a>
            <router-link to="/contact" aria-label="Get in Touch" class="social-icon-link">
              <icon name="material-symbols:mail" class="text-2xl"/>
            </router-link>
          </div>
        </div>

      </div>

      <div class="pt-6 border-t border-surface-700">
        <span class="text-sm footer-copyright">
          &copy; {{ currentYear }} Marek Schir
        </span>
      </div>

    </div>
  </footer>
</template>

<style scoped>
.footer-bg {
  background-color: var(--p-surface-900);
}

.footer-tagline {
  color: var(--p-surface-400);
}

.footer-section-label {
  color: var(--p-surface-500);
}

.footer-nav-link {
  color: var(--p-surface-300);
}

.footer-copyright {
  color: var(--p-surface-500);
}

.social-icon-link {
  display: inline-flex;
  padding: 0.4rem;
  border-radius: 50%;
  color: var(--p-surface-300);
  transition: background-color 0.2s, color 0.2s;
}

.social-icon-link:hover {
  background-color: var(--p-surface-700);
  color: var(--p-surface-100);
}
</style>
