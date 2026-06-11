<script lang="ts" setup>
definePageMeta({ title: 'Integrations & APIs', layout: 'page' })

usePageSeo({
  title: 'Integrations & APIs',
  description: 'Connecting your platforms, building the data flows between them, and designing the API surfaces that make your systems accessible to other tools.',
})

const platforms = 'HubSpot, Jobber, 3CX, FreePBX, Twilio, Stripe, and various CRM and operations platforms.'

const tags = [
  'APIs & webhooks',
  'Custom middleware',
  'API design',
  'MCP servers',
  'Web scraping & proxies',
  'Legacy database access',
]
</script>

<template>
  <div class="flex flex-col gap-8">

    <div class="flex flex-col gap-2">
      <nuxt-link to="/services" class="text-xs uppercase tracking-widest font-medium text-muted-color hover:text-color transition-colors">Services</nuxt-link>
      <h1 class="text-4xl font-bold">Integrations &amp; APIs</h1>
    </div>

    <service-sibling-nav />

    <p class="text-lg leading-relaxed">
      I connect platforms, build APIs, and design the data flows between them. Before any code gets
      written, I map what you have and where the gaps are.
    </p>

    <p-panel>
      <template #header>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">What This Covers</span>
      </template>
      <div class="flex flex-wrap gap-2">
        <p-chip v-for="tag in tags" :key="tag" :label="tag" />
      </div>
    </p-panel>

    <p-panel>
      <template #header>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">My Approach</span>
      </template>
      <div class="flex flex-col gap-4">
        <p class="leading-relaxed text-muted-color">
          My default is Python. More flexibility than point-and-click tools, easier to layer AI into,
          and none of the escalating costs that Zapier accumulates as your automation footprint grows.
        </p>
        <p class="leading-relaxed text-muted-color">
          A platform doesn't need an existing API to be connectable. An accessible database or
          scriptable web interface is usually enough.
        </p>
      </div>
    </p-panel>

    <p-panel>
      <template #header>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Platforms I've Worked With</span>
      </template>
      <p class="leading-relaxed text-muted-color">
        {{ platforms }} If your system has a database, an API, or a web interface, there's usually a way in.
      </p>
    </p-panel>

    <div class="flex justify-center">
      <nuxt-link to="/contact">
        <p-button label="Get in Touch" class="btn-accent" />
      </nuxt-link>
    </div>

  </div>
</template>
