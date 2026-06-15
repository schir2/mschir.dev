<script lang="ts" setup>
import type {Crumb} from "~/types/Article";

const props = defineProps<{breadcrumbs: Crumb[]}>()

const parentCrumb = computed<Crumb | null>(() => {
  if (props.breadcrumbs.length < 2) return null
  return props.breadcrumbs[props.breadcrumbs.length - 2]
})
</script>

<template>
  <nav aria-label="Breadcrumb">
    <nuxt-link
      v-if="parentCrumb?.route"
      :to="parentCrumb.route"
      class="sm:hidden flex items-center gap-1.5 text-sm text-primary hover:underline"
    >
      <icon name="material-symbols:arrow-back" class="text-base shrink-0"/>
      <span>{{ parentCrumb.label }}</span>
    </nuxt-link>

    <ol class="hidden sm:flex items-center flex-wrap gap-1 text-sm">
      <li
        v-for="(crumb, index) in breadcrumbs"
        :key="index"
        class="flex items-center gap-1"
      >
        <span v-if="index > 0" class="text-surface-400" aria-hidden="true">/</span>
        <nuxt-link
          v-if="crumb.route"
          :to="crumb.route"
          class="text-primary font-semibold hover:underline"
        >{{ crumb.label }}</nuxt-link>
        <span v-else class="text-surface-700 dark:text-surface-0">{{ crumb.label }}</span>
      </li>
    </ol>
  </nav>
</template>
