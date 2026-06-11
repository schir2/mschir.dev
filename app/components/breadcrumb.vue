<script lang="ts" setup>
import type {Crumb} from "~/types/Article";

defineProps<{breadcrumbs: Crumb[]}>()
</script>
<template>
  <p-breadcrumb :model="breadcrumbs">
    <template #item="{ item, props }">
      <nuxt-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom>
        <a :href="href" v-bind="props.action" @click="navigate">
          <span :class="[item.icon, 'text-color']" />
          <span class="text-primary font-semibold">{{ item.label }}</span>
        </a>
      </nuxt-link>
      <a v-else :href="item.url" :target="item.target" v-bind="props.action">
        <span class="text-surface-700 dark:text-surface-0">{{ item.label }}</span>
      </a>
    </template>
  </p-breadcrumb>
</template>