<script lang="ts" setup>
definePageMeta({title: 'Message Sent', layout: 'page'})
</script>

<template>
  <section class="flex flex-col items-center justify-center py-24 gap-6 text-center">
    <icon name="material-symbols:check-circle" class="text-green-400 text-6xl"/>
    <h2 class="text-3xl font-bold">Message sent</h2>
    <p class="text-surface-400 max-w-md">
      Your message landed. I will get back to you as soon as I can.
    </p>
    <div class="flex gap-4 pt-2">
      <nuxt-link to="/portfolio">
        <p-button label="See my work" class="btn-accent"/>
      </nuxt-link>
      <nuxt-link to="/articles">
        <p-button label="Read some articles" severity="secondary" outlined/>
      </nuxt-link>
    </div>
  </section>
</template>
