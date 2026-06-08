<script lang="ts" setup>
definePageMeta({ title: 'Services', layout: 'page' })

usePageSeo({
  title: 'Services',
  description: 'Software and integrations for growing businesses. Integrations & APIs, Application Development, and AI & Automation.',
})

const services = [
  {
    key: 'integrations-apis',
    icon: 'material-symbols:hub',
    title: 'Integrations & APIs',
    to: '/services/integrations-apis',
    description: 'Connecting your platforms, building the data flows between them, and designing the API surfaces that make your systems accessible to other tools. CRM platforms, phone systems, legacy applications, and anything else that needs to talk to anything else.',
  },
  {
    key: 'application-development',
    icon: 'material-symbols:code-blocks',
    title: 'Application Development',
    to: '/services/application-development',
    description: 'Custom software built around how your business actually works. Focused on smaller, well-scoped builds that replace a specific manual process or fill a gap that off-the-shelf tools can\'t cover.',
  },
  {
    key: 'ai-automation',
    icon: 'material-symbols:smart-toy',
    title: 'AI & Automation',
    to: '/services/ai-automation',
    description: 'Workflow automation and AI-enriched pipelines that reduce manual work and surface information your team can act on. Most of the opportunity isn\'t where people expect to find it.',
  },
]
</script>

<template>
  <div class="flex flex-col gap-16">

    <div class="flex flex-col gap-6">
      <h1 class="text-4xl font-bold">Services</h1>
      <p class="text-lg leading-relaxed">
        I work with small and mid-sized businesses to build the software and integrations that help
        them run better.
      </p>
      <p class="leading-relaxed text-muted-color">
        Most businesses I work with have grown into a collection of tools and processes that were
        each reasonable on their own but never quite fit together. Data gets re-entered manually.
        Workflows live in someone's head. Software that worked fine a few years ago is starting to
        show its age. The work I do is about closing those gaps — not with the most sophisticated
        solution available, but with the right one given the time, budget, and people involved.
      </p>
      <p class="leading-relaxed text-muted-color">
        Before anything gets built, I start with a systems audit. That means sitting down with you,
        mapping what you have, and identifying where the highest-return changes are. Some of those
        are quick. Others take longer. Either way, you know what you're getting into before any
        work begins.
      </p>
    </div>

    <div class="flex flex-col gap-6">
      <span class="text-xs uppercase tracking-widest font-medium text-muted-color">What I Work On</span>
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
        <nuxt-link
          v-for="service in services"
          :key="service.key"
          :to="service.to"
          class="pillar-card group relative flex items-center gap-6 p-6 rounded-xl border border-surface-200 bg-surface-100 dark:border-surface-700 dark:bg-surface-900 overflow-hidden"
        >
          <div class="pillar-top-bar absolute inset-x-0 top-0 h-0.5" />
          <div class="flex flex-col gap-2 flex-1">
            <h2 class="text-2xl font-semibold leading-tight">{{ service.title }}</h2>
            <p class="text-base leading-relaxed text-muted-color">{{ service.description }}</p>
          </div>
          <icon :name="service.icon" class="pillar-icon flex-shrink-0 text-6xl" />
        </nuxt-link>
      </div>
    </div>

    <div class="flex flex-col items-center text-center gap-6 py-8">
      <p class="text-lg leading-relaxed max-w-lg">
        Got a system, workflow, or idea that needs the right technology behind it? Let's talk.
      </p>
      <nuxt-link to="/contact">
        <p-button label="Get in Touch" class="btn-accent" />
      </nuxt-link>
    </div>

  </div>
</template>

<style scoped>
.pillar-icon {
  color: var(--p-accent-400);
  transition: transform 0.3s, filter 0.3s;
}

.pillar-card {
  transition: border-color 0.3s, box-shadow 0.3s;
}

.pillar-card:hover {
  border-color: color-mix(in srgb, var(--p-accent-500) 50%, transparent);
  box-shadow: 0 0 48px -8px color-mix(in srgb, var(--p-accent-500) 30%, transparent);
}

.pillar-card:hover .pillar-icon {
  transform: scale(1.1);
  filter: brightness(1.2);
}

.pillar-top-bar {
  background: linear-gradient(to right, transparent, var(--p-accent-500), transparent);
  opacity: 0;
  transition: opacity 0.3s;
}

.pillar-card:hover .pillar-top-bar {
  opacity: 1;
}
</style>
