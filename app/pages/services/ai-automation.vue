<script lang="ts" setup>
definePageMeta({ title: 'AI & Automation', layout: 'page' })

usePageSeo({
  title: 'AI & Automation',
  description: 'Workflow automation and AI-enriched pipelines that reduce manual work and surface information your team can act on.',
})

const tags = [
  'Inbound processing',
  'CRM enrichment',
  'Gap alerting',
  'Decision tracking',
  'Knowledge base',
  'AI advisory',
]
</script>

<template>
  <div class="flex flex-col gap-8">

    <div class="flex flex-col gap-2">
      <nuxt-link to="/services" class="text-xs uppercase tracking-widest font-medium text-muted-color hover:text-color transition-colors">Services</nuxt-link>
      <h1 class="text-4xl font-bold">AI &amp; Automation</h1>
    </div>

    <service-sibling-nav />

    <p class="text-lg leading-relaxed">
      The real leverage in AI isn't the chatbot. It's applying it to the data already moving through
      the business: pulling structure out of emails, calls, and job records, and putting it in front
      of the people who need to act on it.
    </p>

    <p-panel>
      <template #header>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">What This Covers</span>
      </template>
      <div class="flex flex-col gap-4">
        <div class="flex flex-wrap gap-2">
          <p-chip v-for="tag in tags" :key="tag" :label="tag" />
        </div>
        <p class="leading-relaxed text-muted-color">
          Automation doesn't require AI to be valuable. A lot of the highest-return work is
          straightforward: remove a manual step, route data automatically, trigger the right action
          when the right event happens. AI gets added when the input is unstructured and you need to
          extract meaning rather than just move a field.
        </p>
      </div>
    </p-panel>

    <p-panel>
      <template #header>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">On Centralizing Company Knowledge</span>
      </template>
      <div class="flex flex-col gap-4">
        <p class="leading-relaxed text-muted-color">
          One of the bigger opportunities I see for most businesses is getting their institutional
          knowledge out of people's heads and into a system. Decisions get made in small meetings.
          Tasks get assigned and forgotten. Important context lives with one person who then leaves
          or gets pulled in another direction.
        </p>
        <p class="leading-relaxed text-muted-color">
          A well-built AI system can track conversations, surface conflicts between decisions, flag
          things that were supposed to happen but didn't, and help different parts of a business
          stay aligned without requiring everyone to be in the same room.
        </p>
      </div>
    </p-panel>

    <p-panel>
      <template #header>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">On Replacing People</span>
      </template>
      <div class="flex flex-col gap-4">
        <p class="leading-relaxed text-muted-color">
          There's a lot of pressure right now to use AI to cut headcount. That's not the approach
          I take.
        </p>
        <p class="leading-relaxed text-muted-color">
          The businesses that get the most out of AI automation are the ones that use it to make
          their people more effective. Less time on repetitive data entry. Fewer things falling
          through the cracks. Better information in front of the people who need it.
        </p>
        <p class="leading-relaxed text-muted-color">
          Full replacement carries real risks: institutional knowledge loss, morale, and the fact
          that AI systems still need people to manage and correct them. I'm happy to have that
          conversation honestly if you're weighing it.
        </p>
      </div>
    </p-panel>

    <div class="flex justify-center">
      <nuxt-link to="/contact">
        <p-button label="Get in Touch" class="btn-accent" />
      </nuxt-link>
    </div>

  </div>
</template>
