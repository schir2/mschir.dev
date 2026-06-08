<script lang="ts" setup>
// Prototype: Where should the h1 sit relative to the Service Sibling Nav?
// All variants use the icon card strip (Variant C was chosen).
// This prototype explores title positioning only.
definePageMeta({ title: 'Prototype: Service Nav — Title Placement', layout: 'page' })

const route = useRoute()
const variant = computed(() => (route.query.variant as string) ?? 'A')

const variants = [
  { key: 'A', label: 'Nav → Title' },
  { key: 'B', label: 'Title → Nav' },
  { key: 'C', label: '"Services" eyebrow → Title → Nav' },
]

const services = [
  { key: 'integrations-apis', label: 'Integrations & APIs', icon: 'material-symbols:hub', to: '/services/integrations-apis' },
  { key: 'application-development', label: 'Application Development', icon: 'material-symbols:code-blocks', to: '/services/application-development' },
  { key: 'ai-automation', label: 'AI & Automation', icon: 'material-symbols:smart-toy', to: '/services/ai-automation' },
]

const activeKey = 'ai-automation'
</script>

<template>
  <div class="flex flex-col gap-12 pb-32">
    <div class="flex flex-col gap-2">
      <p class="text-xs uppercase tracking-widest font-medium text-muted-color">Prototype — icon card strip, title placement</p>
      <p class="text-sm text-muted-color">All variants use the same icon card nav. Switch variants with ← → keys to compare placements.</p>
    </div>

    <!-- Shared nav strip — reused across all variants -->
    <template v-if="variant === 'A' || variant === 'B' || variant === 'C'">

      <!-- ====== A: Nav → Title ====== -->
      <div v-if="variant === 'A'" class="flex flex-col gap-6">
        <div class="grid grid-cols-3 gap-4">
          <nuxt-link
            v-for="service in services"
            :key="service.key"
            :to="service.to"
            class="flex items-center gap-3 p-4 rounded-xl border transition-all"
            :class="service.key === activeKey
              ? 'border-amber-500/60 bg-amber-500/10 text-color'
              : 'border-surface-700 bg-surface-900 text-muted-color hover:border-surface-500 hover:text-color'"
          >
            <icon :name="service.icon" class="text-2xl flex-shrink-0" :class="service.key === activeKey ? 'text-amber-400' : ''" />
            <span class="text-sm font-medium leading-tight">{{ service.label }}</span>
          </nuxt-link>
        </div>
        <h1 class="text-4xl font-bold">AI &amp; Automation</h1>
        <service-nav-body />
      </div>

      <!-- ====== B: Title → Nav ====== -->
      <div v-else-if="variant === 'B'" class="flex flex-col gap-6">
        <h1 class="text-4xl font-bold">AI &amp; Automation</h1>
        <div class="grid grid-cols-3 gap-4">
          <nuxt-link
            v-for="service in services"
            :key="service.key"
            :to="service.to"
            class="flex items-center gap-3 p-4 rounded-xl border transition-all"
            :class="service.key === activeKey
              ? 'border-amber-500/60 bg-amber-500/10 text-color'
              : 'border-surface-700 bg-surface-900 text-muted-color hover:border-surface-500 hover:text-color'"
          >
            <icon :name="service.icon" class="text-2xl flex-shrink-0" :class="service.key === activeKey ? 'text-amber-400' : ''" />
            <span class="text-sm font-medium leading-tight">{{ service.label }}</span>
          </nuxt-link>
        </div>
        <service-nav-body />
      </div>

      <!-- ====== C: "Services" eyebrow → Title → Nav ====== -->
      <div v-else-if="variant === 'C'" class="flex flex-col gap-6">
        <div class="flex flex-col gap-2">
          <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Services</span>
          <h1 class="text-4xl font-bold">AI &amp; Automation</h1>
        </div>
        <div class="grid grid-cols-3 gap-4">
          <nuxt-link
            v-for="service in services"
            :key="service.key"
            :to="service.to"
            class="flex items-center gap-3 p-4 rounded-xl border transition-all"
            :class="service.key === activeKey
              ? 'border-amber-500/60 bg-amber-500/10 text-color'
              : 'border-surface-700 bg-surface-900 text-muted-color hover:border-surface-500 hover:text-color'"
          >
            <icon :name="service.icon" class="text-2xl flex-shrink-0" :class="service.key === activeKey ? 'text-amber-400' : ''" />
            <span class="text-sm font-medium leading-tight">{{ service.label }}</span>
          </nuxt-link>
        </div>
        <service-nav-body />
      </div>

    </template>

    <prototype-switcher :variants="variants" />
  </div>
</template>
