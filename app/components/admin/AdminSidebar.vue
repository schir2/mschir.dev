<script lang="ts" setup>
import { toSidebarMenuItems } from '~/config/adminSections'

const menuItems = toSidebarMenuItems()
</script>

<template>
  <aside class="w-48 shrink-0 bg-surface-900 sticky top-20 h-[calc(100vh-5rem)] overflow-y-auto self-start">
    <p-menu :model="menuItems" class="w-full border-none rounded-none">
      <template #item="{ item }">
        <nuxt-link
          v-if="item.to"
          :to="item.to"
          class="flex items-center gap-2 px-4 py-2 text-sm w-full"
          active-class="text-primary font-medium"
        >
          <icon v-if="item.icon" :name="item.icon" class="text-base shrink-0" />
          <span>{{ item.label }}</span>
        </nuxt-link>
      </template>
    </p-menu>
  </aside>
</template>
