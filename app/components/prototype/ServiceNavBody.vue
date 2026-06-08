<template>
  <div class="flex flex-col gap-8 max-w-2xl">
    <p class="text-lg leading-relaxed">
      Most people think of AI as a chatbot. The more useful version is quieter: it reads your emails,
      processes your job notes, identifies what needs to happen next, and creates the tasks, tickets,
      and notifications before anyone has to think about it.
    </p>

    <div class="flex flex-col gap-4">
      <h2>What this typically involves</h2>
      <p class="leading-relaxed text-muted-color">
        Automation doesn't require AI to be valuable. A lot of the highest-return work is
        straightforward: remove a manual step, route data automatically, trigger the right action
        when the right event happens. AI gets added when the input is unstructured — when you need
        to extract meaning from a conversation, a set of notes, or a pile of emails.
      </p>
      <ul class="flex flex-col gap-2 pl-4">
        <li v-for="item in involves" :key="item" class="text-muted-color leading-relaxed list-disc">{{ item }}</li>
      </ul>
    </div>

    <div class="flex flex-col gap-4">
      <h2>Who this is for</h2>
      <p class="leading-relaxed text-muted-color">
        Business owners who suspect their team is spending too much time on work that should be
        automatic. Companies using a CRM that aren't getting full value from the data flowing
        through them. Anyone curious about what AI automation actually looks like in a real
        business, beyond the chatbot demos.
      </p>
    </div>

    <nuxt-link to="/contact">
      <p-button label="Get in Touch" class="btn-accent" />
    </nuxt-link>
  </div>
</template>

<script lang="ts" setup>
const involves = [
  'Processing inbound communications to extract next steps and create tasks automatically',
  'Enriching CRM records with data from other systems so your team isn\'t filling in fields manually',
  'Building alerting systems that surface missed opportunities before they become problems',
  'Tracking meetings and decisions across teams so nothing important gets lost',
  'Helping owners and teams understand what AI can actually do for their business',
]
</script>
