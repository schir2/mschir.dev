<script lang="ts" setup>
// Prototype: Where should the h1 sit relative to the series dropdown?
// Variant B (p-select + prev/next) was chosen. This explores title positioning.
definePageMeta({ title: 'Prototype: Series Nav — Title Placement', layout: 'page' })

const route = useRoute()
const variant = computed(() => (route.query.variant as string) ?? 'A')

const variants = [
  { key: 'A', label: 'Dropdown → Title' },
  { key: 'B', label: 'Title → Dropdown' },
  { key: 'C', label: 'Series eyebrow → Title → Dropdown' },
  { key: 'D', label: 'Title → Series subtitle → Dropdown' },
]

const CURRENT_PART = 7
const TOTAL = 19

const articles = [
  { part: 1, title: 'Why Field Service Software Is Harder Than It Looks', slug: 'field-service-why-hard' },
  { part: 2, title: 'Mapping the Business Before Writing Any Code', slug: 'field-service-mapping' },
  { part: 3, title: 'Choosing a Stack for a Long-Lived Internal Tool', slug: 'field-service-stack' },
  { part: 4, title: 'Designing the Job Model', slug: 'field-service-job-model' },
  { part: 5, title: 'Technician Dispatch and Scheduling Constraints', slug: 'field-service-dispatch' },
  { part: 6, title: 'Integrating with the Phone System', slug: 'field-service-phone' },
  { part: 7, title: 'Building the Customer Portal', slug: 'field-service-customer-portal' },
  { part: 8, title: 'Real-time GPS Tracking Without Overengineering It', slug: 'field-service-gps' },
  { part: 9, title: 'Invoice Generation and the Accounting Integration', slug: 'field-service-invoicing' },
  { part: 10, title: 'Handling Offline Mobile Scenarios', slug: 'field-service-offline' },
  { part: 11, title: 'Role-Based Access and What "Admin" Actually Means', slug: 'field-service-rbac' },
  { part: 12, title: 'Reporting That Managers Actually Use', slug: 'field-service-reporting' },
  { part: 13, title: 'Migrating Data from the Old System', slug: 'field-service-migration' },
  { part: 14, title: 'Testing Without a Full Staging Environment', slug: 'field-service-testing' },
  { part: 15, title: 'The First Production Incident and What We Changed', slug: 'field-service-incident' },
  { part: 16, title: 'Performance Problems at Scale and How We Fixed Them', slug: 'field-service-performance' },
  { part: 17, title: 'The Features We Cut and Why', slug: 'field-service-cuts' },
  { part: 18, title: 'What the Business Learned From the Software', slug: 'field-service-lessons' },
  { part: 19, title: 'Two Years Later: What Held Up and What Didn\'t', slug: 'field-service-retrospective' },
]

const currentArticle = articles.find(a => a.part === CURRENT_PART)!
const previousArticle = articles.find(a => a.part === CURRENT_PART - 1) ?? null
const nextArticle = articles.find(a => a.part === CURRENT_PART + 1) ?? null

const selectOptions = articles.map(article => ({
  label: `Part ${article.part} of ${TOTAL} — ${article.title}`,
  value: article.part,
}))
const selectedPart = ref(CURRENT_PART)
</script>

<template>
  <div class="flex flex-col gap-12 pb-32">
    <div class="flex flex-col gap-2">
      <p class="text-xs uppercase tracking-widest font-medium text-muted-color">Prototype — series dropdown, title placement</p>
      <p class="text-sm text-muted-color">All variants use the same p-select dropdown + prev/next strip. Switch with ← → keys.</p>
    </div>

    <!-- ====== A: Dropdown → Title ====== -->
    <div v-if="variant === 'A'" class="flex flex-col gap-8 max-w-2xl">
      <p-select v-model="selectedPart" :options="selectOptions" option-label="label" option-value="value" class="w-full" />
      <h1 class="text-4xl font-bold">{{ currentArticle.title }}</h1>
      <article-body-placeholder />
      <series-prev-next :previous-article="previousArticle" :next-article="nextArticle" />
    </div>

    <!-- ====== B: Title → Dropdown ====== -->
    <div v-else-if="variant === 'B'" class="flex flex-col gap-8 max-w-2xl">
      <h1 class="text-4xl font-bold">{{ currentArticle.title }}</h1>
      <p-select v-model="selectedPart" :options="selectOptions" option-label="label" option-value="value" class="w-full" />
      <article-body-placeholder />
      <series-prev-next :previous-article="previousArticle" :next-article="nextArticle" />
    </div>

    <!-- ====== C: Series eyebrow → Title → Dropdown ====== -->
    <div v-else-if="variant === 'C'" class="flex flex-col gap-8 max-w-2xl">
      <div class="flex flex-col gap-2">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Series · Building Field Service Software</span>
        <h1 class="text-4xl font-bold">{{ currentArticle.title }}</h1>
      </div>
      <p-select v-model="selectedPart" :options="selectOptions" option-label="label" option-value="value" class="w-full" />
      <article-body-placeholder />
      <series-prev-next :previous-article="previousArticle" :next-article="nextArticle" />
    </div>

    <!-- ====== D: Title → Series subtitle → Dropdown ====== -->
    <div v-else-if="variant === 'D'" class="flex flex-col gap-8 max-w-2xl">
      <div class="flex flex-col gap-1">
        <h1 class="text-4xl font-bold">{{ currentArticle.title }}</h1>
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">
          Part {{ CURRENT_PART }} of {{ TOTAL }} · <a href="#" class="hover:text-color transition-colors">Building Field Service Software</a>
        </span>
      </div>
      <p-select v-model="selectedPart" :options="selectOptions" option-label="label" option-value="value" class="w-full" />
      <article-body-placeholder />
      <series-prev-next :previous-article="previousArticle" :next-article="nextArticle" />
    </div>

    <prototype-switcher :variants="variants" />
  </div>
</template>
