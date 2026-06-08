<script lang="ts" setup>
definePageMeta({ title: 'AI & Automation', layout: 'page' })

usePageSeo({
  title: 'AI & Automation',
  description: 'Workflow automation and AI-enriched pipelines that reduce manual work and surface information your team can act on.',
})

const involves = [
  'Processing inbound communications (emails, messages, call notes) to extract next steps and create tasks automatically',
  'Enriching CRM records with data from other systems so your team isn\'t filling in fields manually',
  'Building alerting systems that surface missed opportunities and gaps before they become problems',
  'Tracking meetings and decisions across teams so nothing important gets lost between conversations',
  'Building out a centralised knowledge base so the information your business generates actually gets captured, organised, and used',
  'Helping owners and teams understand what AI can actually do for their business, what\'s realistic, what isn\'t, and where the highest-return opportunities usually are',
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
      Most people think of AI as a chatbot. The more useful version is quieter: it reads your emails,
      processes your job notes, identifies what needs to happen next, and creates the tasks, tickets,
      and notifications before anyone has to think about it.
    </p>
    <p class="leading-relaxed">
      That's the kind of work I do here.
    </p>

    <div class="flex flex-col gap-4">
      <h2>What this typically involves</h2>
      <p class="leading-relaxed text-muted-color">
        Automation doesn't require AI to be valuable. A lot of the highest-return work is
        straightforward: remove a manual step, route data automatically, trigger the right action
        when the right event happens. I start there.
      </p>
      <p class="leading-relaxed text-muted-color">
        AI gets added when the input is unstructured. When you need to extract meaning from a
        conversation, a set of notes, or a pile of emails rather than just moving a field from one
        system to another. The combination of automation infrastructure and AI processing is where
        the real leverage is.
      </p>
      <ul class="flex flex-col gap-2">
        <li v-for="item in involves" :key="item" class="flex gap-3 leading-relaxed text-muted-color">
          <span class="text-amber-400 flex-shrink-0 mt-1">—</span>
          <span>{{ item }}</span>
        </li>
      </ul>
    </div>

    <div class="flex flex-col gap-4">
      <h2>On centralizing company knowledge</h2>
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

    <div class="flex flex-col gap-4">
      <h2>On replacing people</h2>
      <p class="leading-relaxed text-muted-color">
        There's a lot of pressure right now to use AI to cut headcount. That's not the approach
        I take.
      </p>
      <p class="leading-relaxed text-muted-color">
        The businesses that get the most out of AI automation are the ones that use it to make
        their people more effective. Less time on repetitive data entry. Fewer things falling
        through the cracks. Better information in front of the people who need it. The employees
        who add real value get amplified. The manual work that was eating their time goes away.
      </p>
      <p class="leading-relaxed text-muted-color">
        Full replacement carries real risks: institutional knowledge loss, morale, and the fact
        that AI systems still need people to manage and correct them. I'm happy to have that
        conversation honestly if you're weighing it.
      </p>
    </div>

    <div class="flex flex-col gap-4">
      <h2>Who this is for</h2>
      <p class="leading-relaxed text-muted-color">
        Business owners who suspect their team is spending too much time on work that should be
        automatic. Companies using a CRM or customer management system that aren't getting full
        value from the data flowing through them. Anyone curious about what AI automation actually
        looks like in a real business, beyond the chatbot demos.
      </p>
      <p class="leading-relaxed text-muted-color">
        You don't need a technical background to have this conversation. Most of the useful work
        starts with understanding your workflow, not your tech stack.
      </p>
    </div>

    <div>
      <nuxt-link to="/contact">
        <p-button label="Get in Touch" class="btn-accent" />
      </nuxt-link>
    </div>

  </div>
</template>
