<script lang="ts" setup>
defineProps<{
  editorId: string
}>()

const isExpanded = ref<boolean>(true)
const mdTheme = useMdEditorTheme()
</script>

<template>
  <client-only>
    <div class="hidden lg:block fixed top-24 right-4 z-50">
      <div class="flex flex-col items-end gap-2">
        <p-button
          :icon="isExpanded ? 'pi pi-angle-right' : 'pi pi-angle-left'"
          text
          rounded
          size="small"
          :aria-label="isExpanded ? 'Collapse table of contents' : 'Expand table of contents'"
          @click="isExpanded = !isExpanded"
        />
        <div
          v-if="isExpanded"
          class="border border-surface-200 rounded-lg p-3 max-w-64 max-h-[70vh] overflow-y-auto shadow-md"
          style="background: var(--p-surface-card)"
        >
          <md-catalog
            :editor-id="editorId"
            :theme="mdTheme"
            scroll-element="html"
          />
        </div>
      </div>
    </div>
  </client-only>
</template>
