<script lang="ts" setup>
definePageMeta({ title: 'Application Development', layout: 'page' })

usePageSeo({
  title: 'Application Development',
  description: 'Custom software built around how your business actually works. Focused on smaller, well-scoped builds that replace a specific manual process or fill a gap that off-the-shelf tools can\'t cover.',
})

const projects = [
  { name: 'Arcus', slug: 'arcus', description: 'Field service management system built around real technician workflows.' },
  { name: 'Calcura', slug: 'calcura', description: 'Calculation and estimation tool for field operations.' },
  { name: 'Visual Lead Inspection & Job Tracking System', slug: 'visual-lead-inspection-job-tracking-system', description: 'Job tracking and inspection system replacing a manual paper-based process.' },
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
      Some businesses need software built from scratch. Others have systems that were built for an
      earlier version of the company and have been holding together longer than they should. Both
      are things I work on, within the right scope.
    </p>
    <p class="leading-relaxed">
      This isn't the right fit for large-scale platforms that need a full development team. What I
      do well are focused builds: a tool that replaces a specific manual process, an internal system
      that off-the-shelf software can't cover, or a smaller application that a business actually
      needs but nobody has gotten around to building.
    </p>

    <div class="flex flex-col gap-4">
      <h2>What this typically involves</h2>
      <p class="leading-relaxed text-muted-color">
        Before any design or development begins, I document the business process. Not the ideal
        version, but the one that actually exists today, with all its workarounds and edge cases.
        That documentation becomes the spec.
      </p>
      <p class="leading-relaxed text-muted-color">
        One thing that comes up often in this work is the gap between how hard something looks and
        how hard it actually is. Business owners sometimes come in expecting a straightforward build
        that turns out to be deeply tangled once the process gets unraveled. The opposite happens
        too. Getting that honest assessment early saves a lot of time and money later, and it's
        something I try to give before any commitment is made on either side.
      </p>
      <p class="leading-relaxed text-muted-color">
        From there the scope varies. It might be a tool with authentication, scheduling, reporting,
        and an admin interface. It might be a single screen that automates one expensive manual
        step. Timeline depends on how complex the underlying process turns out to be.
      </p>
    </div>

    <div class="flex flex-col gap-4">
      <h2>Projects</h2>
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
    </div>

    <div class="flex flex-col gap-4">
      <h2>Who this is for</h2>
      <p class="leading-relaxed text-muted-color">
        Business owners running on spreadsheets and email for something that should have a system.
        Teams with software that no longer fits how the business actually works. Companies that have
        tried off-the-shelf tools and found they don't map to the real process.
      </p>
      <p class="leading-relaxed text-muted-color">
        If the problem is well-defined and the scope is realistic, it can be built.
      </p>
    </div>

    <div>
      <nuxt-link to="/contact">
        <p-button label="Get in Touch" class="btn-accent" />
      </nuxt-link>
    </div>

  </div>
</template>
