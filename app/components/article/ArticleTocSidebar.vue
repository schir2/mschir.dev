<script lang="ts" setup>
import {MdCatalog} from '~/utils/mdPreview'

defineProps<{
  editorId: string
}>()

const isExpanded = ref<boolean>(true)
const mdTheme = useMdEditorTheme()
</script>

<template>
  <client-only>
    <div class="hidden 2xl:block fixed top-24 right-4 z-50">
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
          class="toc-panel border border-surface-200 rounded-lg p-3 max-w-64 max-h-[70vh] overflow-y-auto shadow-md"
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

<style scoped>
.toc-panel {
  background: var(--p-surface-card);
}

:deep(.md-editor-catalog-active > span),
:deep(.md-editor-catalog-link span:hover) {
  color: var(--p-primary-500);
}
</style>
