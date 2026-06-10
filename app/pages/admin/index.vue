<script lang="ts" setup>
import { ADMIN_SECTIONS } from '~/config/adminSections'

definePageMeta({ layout: 'admin-list', title: 'Admin' })
</script>

<template>
  <div class="flex flex-col gap-8 pb-8">
    <admin-page-header />

    <div class="flex flex-col gap-6">
      <p-panel v-for="group in ADMIN_SECTIONS" :key="group.label">
        <template #header>
          <span class="text-xs uppercase tracking-widest font-medium text-muted-color">{{ group.label }}</span>
        </template>
        <template v-for="(section, index) in group.sections" :key="section.to">
          <p-divider v-if="index > 0" class="my-0" />
          <div class="flex items-center gap-4 py-2">
            <icon :name="section.icon" class="text-xl text-muted-color shrink-0" />
            <nuxt-link :to="section.to" class="flex-1 text-sm font-medium hover:text-primary">
              {{ section.label }}
            </nuxt-link>
            <p-button
              :label="`Add ${section.singular}`"
              severity="secondary"
              rounded
              size="small"
              @click="navigateTo(`${section.to}/new`)"
            >
              <template #icon>
                <icon name="material-symbols:add-circle" class="text-lg" />
              </template>
            </p-button>
          </div>
        </template>
      </p-panel>
    </div>
  </div>
</template>
