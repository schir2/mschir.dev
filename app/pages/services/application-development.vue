<script lang="ts" setup>
definePageMeta({ title: 'Application Development', layout: 'page' })

usePageSeo({
  title: 'Application Development',
  description: 'Custom software built around how your business actually works. Focused on smaller, well-scoped builds that replace a specific manual process or fill a gap that off-the-shelf tools can\'t cover.',
})

const tags = [
  'Custom builds',
  'Legacy modernization',
  'Internal tooling',
  'Process documentation',
  'Admin interfaces',
]

const projects = [
  { name: 'Arcus', slug: 'arcus', description: 'Personal take on task management, inspired by Asana and Linear, with real-time updates and a clean interface.' },
  { name: 'Calcura', slug: 'calcura', description: 'Retirement scenario planner that shows how savings and investment choices compound over a working lifetime.' },
  { name: 'Visual Lead Inspection & Job Tracking System', slug: 'visual-lead-inspection-job-tracking-system', description: 'Job tracking system with visual inspection workflows.' },
]
</script>

<template>
  <div class="flex flex-col gap-8">

    <div class="flex flex-col gap-2">
      <nuxt-link to="/services" class="text-xs uppercase tracking-widest font-medium text-muted-color hover:text-color transition-colors">Services</nuxt-link>
      <h1 class="text-4xl font-bold">Application Development</h1>
    </div>

    <service-sibling-nav />

    <p class="text-lg leading-relaxed">
      I build focused software: tools that replace a specific manual process, internal systems
      off-the-shelf can't cover, and smaller applications that a business needs but nobody has
      gotten around to building. I'm not the right fit for large-scale platforms that need a full team.
    </p>

    <p-panel>
      <template #header>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">What This Involves</span>
      </template>
      <div class="flex flex-col gap-4">
        <div class="flex flex-wrap gap-2">
          <p-chip v-for="tag in tags" :key="tag" :label="tag" />
        </div>
        <p class="leading-relaxed text-muted-color">
          Before any design or development begins, I document the business process. Not the ideal
          version, but the one that actually exists today, with all its workarounds and edge cases.
          That documentation becomes the spec.
        </p>
        <p class="leading-relaxed text-muted-color">
          One thing that comes up often is the gap between how hard something looks and how hard it
          actually is. Business owners sometimes come in expecting a straightforward build that turns
          out to be deeply tangled once the process gets unraveled. Getting that honest assessment
          early saves a lot of time and money, and it's something I try to give before any commitment
          is made on either side.
        </p>
        <p class="leading-relaxed text-muted-color">
          From there the scope varies. It might be a tool with authentication, scheduling, reporting,
          and an admin interface. It might be a single screen that automates one expensive manual
          step.
        </p>
      </div>
    </p-panel>

    <p-panel>
      <template #header>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Projects</span>
      </template>
      <ul class="flex flex-col gap-4">
        <li v-for="project in projects" :key="project.slug" class="flex flex-col gap-1">
          <nuxt-link
            :to="`/projects/${project.slug}`"
            class="font-medium hover:text-primary transition-colors"
          >
            {{ project.name }}
          </nuxt-link>
          <p class="text-sm text-muted-color">{{ project.description }}</p>
        </li>
      </ul>
    </p-panel>

    <div class="flex justify-center">
      <nuxt-link to="/contact">
        <p-button label="Get in Touch" class="btn-accent" />
      </nuxt-link>
    </div>

  </div>
</template>
