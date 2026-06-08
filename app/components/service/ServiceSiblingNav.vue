<script lang="ts" setup>
const route = useRoute()

const services = [
  { key: 'integrations-apis', label: 'Integrations & APIs', icon: 'material-symbols:hub', to: '/services/integrations-apis' },
  { key: 'application-development', label: 'Application Development', icon: 'material-symbols:code-blocks', to: '/services/application-development' },
  { key: 'ai-automation', label: 'AI & Automation', icon: 'material-symbols:smart-toy', to: '/services/ai-automation' },
]

const activeKey = computed(() => {
  const path = route.path
  return services.find(service => path.endsWith(service.key))?.key ?? null
})
</script>

<template>
  <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
    <nuxt-link
      v-for="service in services"
      :key="service.key"
      :to="service.to"
      class="flex items-center gap-3 p-4 rounded-xl border transition-all"
      :class="service.key === activeKey
        ? 'border-amber-500/60 bg-amber-500/10 text-color'
        : 'border-surface-200 bg-surface-100 dark:border-surface-700 dark:bg-surface-900 text-muted-color hover:border-surface-400 dark:hover:border-surface-500 hover:text-color'"
    >
      <icon
        :name="service.icon"
        class="text-2xl flex-shrink-0 transition-colors"
        :class="service.key === activeKey ? 'text-amber-400' : ''"
      />
      <span class="text-sm font-medium leading-tight">{{ service.label }}</span>
    </nuxt-link>
  </div>
</template>
