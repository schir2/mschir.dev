<script lang="ts" setup>
definePageMeta({ layout: 'admin-list', title: 'Prototype: AdminPageHeader' })
</script>

<template>
  <div class="flex flex-col gap-16 py-8">

    <!-- Variant A: secondary · circular button · plain + icon -->
    <section>
      <p class="text-xs font-semibold uppercase tracking-widest text-muted-color mb-3">
        Variant A — secondary circular · plain + icon
      </p>
      <div class="flex justify-between items-center pt-6 pb-4 mb-6 border-b border-surface-700">
        <h1 class="text-3xl">Articles</h1>
        <p-button rounded severity="secondary" aria-label="New Article">
          <template #icon>
            <icon name="material-symbols:add" />
          </template>
        </p-button>
      </div>
      <div class="border border-dashed border-surface-600 rounded p-6 text-muted-color text-sm text-center">
        — page content —
      </div>
    </section>

    <!-- Variant B: secondary · circular button · add-circle icon (circle-within-circle) -->
    <section>
      <p class="text-xs font-semibold uppercase tracking-widest text-muted-color mb-3">
        Variant B — secondary circular · add-circle icon
      </p>
      <div class="flex justify-between items-center pt-6 pb-4 mb-6 border-b border-surface-700">
        <h1 class="text-3xl">Articles</h1>
        <p-button rounded severity="secondary" aria-label="New Article">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </div>
      <div class="border border-dashed border-surface-600 rounded p-6 text-muted-color text-sm text-center">
        — page content —
      </div>
    </section>

    <!-- Variant C: secondary · add-circle icon + "New Article" label -->
    <section>
      <p class="text-xs font-semibold uppercase tracking-widest text-muted-color mb-3">
        Variant C — secondary · add-circle icon + label
      </p>
      <div class="flex justify-between items-center pt-6 pb-4 mb-6 border-b border-surface-700">
        <h1 class="text-3xl">Articles</h1>
        <p-button label="New Article" rounded severity="secondary">
          <template #icon>
            <icon name="material-symbols:add-circle" />
          </template>
        </p-button>
      </div>
      <div class="border border-dashed border-surface-600 rounded p-6 text-muted-color text-sm text-center">
        — page content —
      </div>
    </section>

  </div>
</template>
