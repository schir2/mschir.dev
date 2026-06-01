<script lang="ts" setup>
interface Crumb {
  label: string
  to?: string
}

const props = defineProps<{
  crumbs: Crumb[]
}>()

const model = computed(() =>
  props.crumbs.map((crumb, index) => ({
    label: crumb.label,
    to: crumb.to,
    disabled: index === props.crumbs.length - 1,
  })),
)
</script>

<template>
  <nav class="hidden md:block mb-4" aria-label="Breadcrumb">
    <p-breadcrumb :model="model">
      <template #item="{ item }">
        <nuxt-link
          v-if="item.to && !item.disabled"
          :to="item.to"
          class="text-sm max-w-[8rem] truncate inline-block"
          :title="item.label"
        >{{ item.label }}</nuxt-link>
        <span
          v-else
          class="text-sm max-w-[14rem] truncate inline-block"
          :title="item.label"
        >{{ item.label }}</span>
      </template>
    </p-breadcrumb>
  </nav>
</template>
