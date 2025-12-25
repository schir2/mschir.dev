<script lang="ts" setup>

</script>
<template>
  <section class="p-8 bg-skin-base rounded-xl border">
    <h2 class="text-3xl font-semibold mb-4">Recent Projects</h2>
    {% include 'arcus/partials/project_list_partial.html' with projects=recent_projects %}
  </section>
</template>
