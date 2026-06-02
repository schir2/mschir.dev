<script setup lang="ts">
definePageMeta({ title: 'Prototype: Project Card', layout: 'page' })

interface Skill {
  id: string
  name: string
  icon: string | null
  category: string
}

interface FixtureProject {
  id: string
  name: string
  year: number
  company: string | null
  summary: string
  tagline: string | null
  skills: Skill[]
  thumbnailColor: string
  featured: boolean
}

const projects: FixtureProject[] = [
  {
    id: '1',
    name: 'Field Service Management Platform',
    year: 2022,
    company: 'MMEnviro',
    summary: 'A full-featured field service management platform built with Django and Vue. Manages technician scheduling, dispatch, and job tracking for a mid-sized environmental services company. Replaced a legacy paper-based workflow, cutting scheduling time by 60%.',
    tagline: 'Job scheduling app for field service companies',
    skills: [
      { id: '1', name: 'Python', icon: 'simple-icons:python', category: 'Languages' },
      { id: '2', name: 'Django', icon: 'simple-icons:django', category: 'Frameworks' },
      { id: '3', name: 'Vue', icon: 'simple-icons:vuedotjs', category: 'Frameworks' },
      { id: '4', name: 'TypeScript', icon: 'simple-icons:typescript', category: 'Languages' },
      { id: '5', name: 'Postgres', icon: 'simple-icons:postgresql', category: 'Databases' },
      { id: '6', name: 'REST', icon: 'mdi:api', category: 'Other' },
      { id: '7', name: 'AWS', icon: 'simple-icons:amazonaws', category: 'Other' },
    ],
    thumbnailColor: 'var(--p-primary-800)',
    featured: true,
  },
  {
    id: '2',
    name: 'Customer Quoting Application',
    year: 2020,
    company: 'MMEnviro',
    summary: 'An internal quoting tool built to streamline the proposal process for the sales team. Generates itemized quotes from a configurable price book, exports to PDF, and sends directly to clients via email.',
    tagline: null,
    skills: [
      { id: '8', name: 'Python', icon: 'simple-icons:python', category: 'Languages' },
      { id: '9', name: 'Django', icon: 'simple-icons:django', category: 'Frameworks' },
      { id: '10', name: 'HTML', icon: 'simple-icons:html5', category: 'Front-End' },
      { id: '11', name: 'MySQL', icon: 'simple-icons:mysql', category: 'Databases' },
    ],
    thumbnailColor: 'var(--p-surface-600)',
    featured: false,
  },
  {
    id: '3',
    name: 'mschir.dev Portfolio & Blog',
    year: 2024,
    company: null,
    summary: 'A personal portfolio and blog built with Nuxt 4 and Supabase. Serves as both a professional showcase and a platform for writing about software development, architecture, and systems thinking.',
    tagline: null,
    skills: [
      { id: '12', name: 'TypeScript', icon: 'simple-icons:typescript', category: 'Languages' },
      { id: '13', name: 'Vue', icon: 'simple-icons:vuedotjs', category: 'Frameworks' },
      { id: '14', name: 'Nuxt', icon: 'simple-icons:nuxtdotjs', category: 'Frameworks' },
      { id: '15', name: 'Tailwind', icon: 'simple-icons:tailwindcss', category: 'Front-End' },
      { id: '16', name: 'Postgres', icon: 'simple-icons:postgresql', category: 'Databases' },
    ],
    thumbnailColor: 'var(--p-primary-950)',
    featured: false,
  },
]

const categoryOrder = ['Languages', 'Frameworks', 'Front-End', 'Databases']

function groupedSkills(projectSkills: Skill[]): Map<string, Skill[]> {
  const filtered = projectSkills.filter(skill => skill.category !== 'Other')
  const groups = new Map<string, Skill[]>()
  for (const cat of categoryOrder) {
    const inCat = filtered.filter(skill => skill.category === cat)
    if (inCat.length) groups.set(cat, inCat)
  }
  return groups
}

function visibleSkills(projectSkills: Skill[], max = 5): Skill[] {
  return projectSkills.slice(0, max)
}

function hiddenCount(projectSkills: Skill[], max = 5): number {
  return Math.max(0, projectSkills.length - max)
}
</script>

<template>
  <div class="flex flex-col gap-16">
    <div>
      <h1 class="mb-1">Project Card Prototypes</h1>
      <p class="text-surface-400 text-sm">Throwaway prototype — hardcoded fixture data, no Supabase. Three cards per variant: featured (with amber bar), regular with company, personal project (no company).</p>
    </div>

    <!-- Variant A: Flat skills, summary always -->
    <section class="flex flex-col gap-3">
      <div class="mb-1">
        <h2 class="text-lg font-semibold">A — Flat skills, summary always shown</h2>
        <p class="text-xs text-surface-500 mt-0.5">All skills as flat icon+name chips. Max 5, +N overflow. Tagline ignored even when featured.</p>
      </div>

      <article
        v-for="project in projects"
        :key="`a-${project.id}`"
        class="group relative flex overflow-hidden rounded-lg border border-surface-800 bg-surface-900 cursor-pointer opacity-85 transition-all duration-200 hover:opacity-100 hover:shadow-xl hover:shadow-black/40 hover:border-surface-700"
      >
        <div v-if="project.featured" class="w-1.5 shrink-0 bg-amber-500 opacity-80 transition-opacity duration-200 group-hover:opacity-100" />
        <div class="flex gap-4 p-4 w-full min-w-0">
          <div class="flex flex-col gap-1.5 flex-1 min-w-0">
            <span class="text-xs text-surface-300">
              {{ project.company ? `${project.company} · ` : '' }}{{ project.year }}
            </span>
            <span class="font-display text-lg font-semibold leading-snug line-clamp-2 group-hover:text-primary-400 transition-colors duration-200">
              {{ project.name }}
            </span>
            <p class="text-sm text-surface-400 line-clamp-3">{{ project.summary }}</p>
            <div class="mt-auto pt-2 border-t border-surface-800 flex flex-wrap items-center gap-2">
              <span
                v-for="skill in visibleSkills(project.skills)"
                :key="skill.id"
                class="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-300 leading-none"
              >
                <icon v-if="skill.icon" :name="skill.icon" class="text-sm shrink-0" />
                {{ skill.name }}
              </span>
              <span v-if="hiddenCount(project.skills) > 0" class="text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-500 leading-none">
                +{{ hiddenCount(project.skills) }}
              </span>
            </div>
          </div>
          <div class="w-24 h-24 shrink-0 rounded-lg self-center" :style="{ backgroundColor: project.thumbnailColor }" />
        </div>
      </article>
    </section>

    <!-- Variant B: Skills grouped by category, Other hidden -->
    <section class="flex flex-col gap-3">
      <div class="mb-1">
        <h2 class="text-lg font-semibold">B — Skills grouped by category, "Other" hidden</h2>
        <p class="text-xs text-surface-500 mt-0.5">Skills grouped under tiny category labels (Languages, Frameworks, Front-End, Databases). REST, AWS, GitHub etc. omitted entirely.</p>
      </div>

      <article
        v-for="project in projects"
        :key="`b-${project.id}`"
        class="group relative flex overflow-hidden rounded-lg border border-surface-800 bg-surface-900 cursor-pointer opacity-85 transition-all duration-200 hover:opacity-100 hover:shadow-xl hover:shadow-black/40 hover:border-surface-700"
      >
        <div v-if="project.featured" class="w-1.5 shrink-0 bg-amber-500 opacity-80 transition-opacity duration-200 group-hover:opacity-100" />
        <div class="flex gap-4 p-4 w-full min-w-0">
          <div class="flex flex-col gap-1.5 flex-1 min-w-0">
            <span class="text-xs text-surface-300">
              {{ project.company ? `${project.company} · ` : '' }}{{ project.year }}
            </span>
            <span class="font-display text-lg font-semibold leading-snug line-clamp-2 group-hover:text-primary-400 transition-colors duration-200">
              {{ project.name }}
            </span>
            <p class="text-sm text-surface-400 line-clamp-3">{{ project.summary }}</p>
            <div class="mt-auto pt-2 border-t border-surface-800 flex flex-col gap-1.5">
              <div
                v-for="[category, categorySkills] in groupedSkills(project.skills)"
                :key="category"
                class="flex items-center gap-2 flex-wrap"
              >
                <span class="text-[10px] uppercase tracking-wider text-surface-600 shrink-0 w-18">{{ category }}</span>
                <span
                  v-for="skill in categorySkills"
                  :key="skill.id"
                  class="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-300 leading-none"
                >
                  <icon v-if="skill.icon" :name="skill.icon" class="text-sm shrink-0" />
                  {{ skill.name }}
                </span>
              </div>
            </div>
          </div>
          <div class="w-24 h-24 shrink-0 rounded-lg self-center" :style="{ backgroundColor: project.thumbnailColor }" />
        </div>
      </article>
    </section>

    <!-- Variant C: Featured tagline as amber pill -->
    <section class="flex flex-col gap-3">
      <div class="mb-1">
        <h2 class="text-lg font-semibold">C — Featured: tagline as amber pill</h2>
        <p class="text-xs text-surface-500 mt-0.5">When featured with a tagline, an amber-bordered pill appears below the title. Summary still shown beneath it. Mirrors the article featured-reason pill.</p>
      </div>

      <article
        v-for="project in projects"
        :key="`c-${project.id}`"
        class="group relative flex overflow-hidden rounded-lg border border-surface-800 bg-surface-900 cursor-pointer opacity-85 transition-all duration-200 hover:opacity-100 hover:shadow-xl hover:shadow-black/40 hover:border-surface-700"
      >
        <div v-if="project.featured" class="w-1.5 shrink-0 bg-amber-500 opacity-80 transition-opacity duration-200 group-hover:opacity-100" />
        <div class="flex gap-4 p-4 w-full min-w-0">
          <div class="flex flex-col gap-1.5 flex-1 min-w-0">
            <span class="text-xs text-surface-300">
              {{ project.company ? `${project.company} · ` : '' }}{{ project.year }}
            </span>
            <span class="font-display text-lg font-semibold leading-snug line-clamp-2 group-hover:text-primary-400 transition-colors duration-200">
              {{ project.name }}
            </span>
            <span
              v-if="project.featured && project.tagline"
              class="self-start text-xs px-2 py-0.5 rounded-full border border-amber-500/50 text-amber-400 leading-none"
            >
              {{ project.tagline }}
            </span>
            <p class="text-sm text-surface-400 line-clamp-3">{{ project.summary }}</p>
            <div class="mt-auto pt-2 border-t border-surface-800 flex flex-wrap items-center gap-2">
              <span
                v-for="skill in visibleSkills(project.skills)"
                :key="skill.id"
                class="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-300 leading-none"
              >
                <icon v-if="skill.icon" :name="skill.icon" class="text-sm shrink-0" />
                {{ skill.name }}
              </span>
              <span v-if="hiddenCount(project.skills) > 0" class="text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-500 leading-none">
                +{{ hiddenCount(project.skills) }}
              </span>
            </div>
          </div>
          <div class="w-24 h-24 shrink-0 rounded-lg self-center" :style="{ backgroundColor: project.thumbnailColor }" />
        </div>
      </article>
    </section>

    <!-- Variant D: Featured tagline replaces summary -->
    <section class="flex flex-col gap-3">
      <div class="mb-1">
        <h2 class="text-lg font-semibold">D — Featured: tagline replaces summary</h2>
        <p class="text-xs text-surface-500 mt-0.5">When featured with a tagline, the tagline fills the summary slot. Summary not shown. Non-featured cards show summary as normal.</p>
      </div>

      <article
        v-for="project in projects"
        :key="`d-${project.id}`"
        class="group relative flex overflow-hidden rounded-lg border border-surface-800 bg-surface-900 cursor-pointer opacity-85 transition-all duration-200 hover:opacity-100 hover:shadow-xl hover:shadow-black/40 hover:border-surface-700"
      >
        <div v-if="project.featured" class="w-1.5 shrink-0 bg-amber-500 opacity-80 transition-opacity duration-200 group-hover:opacity-100" />
        <div class="flex gap-4 p-4 w-full min-w-0">
          <div class="flex flex-col gap-1.5 flex-1 min-w-0">
            <span class="text-xs text-surface-300">
              {{ project.company ? `${project.company} · ` : '' }}{{ project.year }}
            </span>
            <span class="font-display text-lg font-semibold leading-snug line-clamp-2 group-hover:text-primary-400 transition-colors duration-200">
              {{ project.name }}
            </span>
            <p class="text-sm text-surface-400 line-clamp-3">
              {{ (project.featured && project.tagline) ? project.tagline : project.summary }}
            </p>
            <div class="mt-auto pt-2 border-t border-surface-800 flex flex-wrap items-center gap-2">
              <span
                v-for="skill in visibleSkills(project.skills)"
                :key="skill.id"
                class="flex items-center gap-1 text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-300 leading-none"
              >
                <icon v-if="skill.icon" :name="skill.icon" class="text-sm shrink-0" />
                {{ skill.name }}
              </span>
              <span v-if="hiddenCount(project.skills) > 0" class="text-xs px-2.5 py-1 rounded-full bg-surface-800 text-surface-500 leading-none">
                +{{ hiddenCount(project.skills) }}
              </span>
            </div>
          </div>
          <div class="w-24 h-24 shrink-0 rounded-lg self-center" :style="{ backgroundColor: project.thumbnailColor }" />
        </div>
      </article>
    </section>
  </div>
</template>
