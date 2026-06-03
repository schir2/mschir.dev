<script lang="ts" setup>
definePageMeta({ title: 'Prototype: Service Pillars', layout: 'page' })

const pillars = [
  { icon: 'material-symbols:hub', title: 'Integrations & APIs', description: 'Connecting your platforms, building the APIs that tie them together.' },
  { icon: 'material-symbols:code-blocks', title: 'Application Development', description: 'Custom software and legacy modernization for the way your business actually runs.' },
  { icon: 'material-symbols:smart-toy', title: 'AI & Automation', description: 'Workflow automation and AI-enriched pipelines that eliminate the manual work.' },
  { icon: 'material-symbols:cloud', title: 'Infrastructure & Cloud', description: 'Cloud architecture, networking, and security across AWS, Azure, DigitalOcean, and more.' },
]

const colorOptions = [
  { name: 'Indigo',           hex: '#818cf8', glow: 'rgba(99,102,241,0.3)' },
  { name: 'Teal',             hex: '#2dd4bf', glow: 'rgba(45,212,191,0.3)' },
  { name: 'Violet',           hex: '#a78bfa', glow: 'rgba(167,139,250,0.3)' },
  { name: 'Cyan',             hex: '#22d3ee', glow: 'rgba(34,211,238,0.3)' },
  { name: 'Emerald',          hex: '#34d399', glow: 'rgba(52,211,153,0.3)' },
  { name: 'Rose',             hex: '#fb7185', glow: 'rgba(251,113,133,0.3)' },
  { name: 'Amber',            hex: '#fbbf24', glow: 'rgba(251,191,36,0.3)' },
  { name: 'Sky',              hex: '#38bdf8', glow: 'rgba(56,189,248,0.3)' },
]

const activeColor = ref(colorOptions.find(c => c.name === 'Violet')!)
</script>

<template>
  <div class="flex flex-col gap-12 pb-24">

    <div>
      <h1 class="text-3xl mb-2">Service Pillars — Variants</h1>
      <p class="text-muted-color">Pick a color, then compare the three layouts below.</p>
    </div>

    <!-- ── Color selector ─────────────────────────────────────────── -->
    <div class="flex flex-col gap-3">
      <span class="text-xs uppercase tracking-widest font-medium text-muted-color">Accent color</span>
      <div class="flex flex-wrap gap-2">
        <button
          v-for="color in colorOptions"
          :key="color.name"
          class="flex items-center gap-2 px-3 py-2 rounded-lg border text-sm font-medium transition-all duration-150"
          :class="activeColor.name === color.name
            ? 'border-surface-400 bg-surface-800'
            : 'border-surface-700 bg-surface-900 hover:border-surface-500'"
          @click="activeColor = color"
        >
          <span class="w-3 h-3 rounded-full flex-shrink-0" :style="{ backgroundColor: color.hex }"/>
          {{ color.name }}
        </button>
      </div>
    </div>

    <!-- ── Variants with live color ───────────────────────────────── -->
    <div
      class="flex flex-col gap-20"
      :style="{ '--proto-accent': activeColor.hex, '--proto-glow': activeColor.glow }"
    >

      <!-- C2: Icon centered ──────────────────────────────────────── -->
      <section class="flex flex-col gap-6">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">C2 — Icon centered</span>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
          <div
            v-for="pillar in pillars"
            :key="pillar.title"
            class="pillar-card group relative flex flex-col items-center text-center gap-5 p-7 rounded-xl border border-surface-700 bg-surface-900 cursor-default overflow-hidden"
          >
            <div class="pillar-top-bar absolute inset-x-0 top-0 h-0.5"/>
            <icon :name="pillar.icon" class="pillar-icon text-6xl"/>
            <div class="flex flex-col gap-2">
              <h3 class="font-display text-2xl font-semibold leading-tight">{{ pillar.title }}</h3>
              <p class="text-base leading-relaxed text-muted-color">{{ pillar.description }}</p>
            </div>
          </div>
        </div>
      </section>

      <!-- C3: Icon right, vertically centered ────────────────────── -->
      <section class="flex flex-col gap-6">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">C3 — Icon right</span>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
          <div
            v-for="pillar in pillars"
            :key="pillar.title"
            class="pillar-card group relative flex items-center gap-5 p-7 rounded-xl border border-surface-700 bg-surface-900 cursor-default overflow-hidden"
          >
            <div class="pillar-top-bar absolute inset-x-0 top-0 h-0.5"/>
            <div class="flex flex-col gap-2 flex-1">
              <h3 class="font-display text-2xl font-semibold leading-tight">{{ pillar.title }}</h3>
              <p class="text-base leading-relaxed text-muted-color">{{ pillar.description }}</p>
            </div>
            <icon :name="pillar.icon" class="pillar-icon flex-shrink-0 text-6xl"/>
          </div>
        </div>
      </section>

      <!-- C4: Icon escaping 25% ──────────────────────────────────── -->
      <section class="flex flex-col gap-6">
        <span class="text-xs uppercase tracking-widest font-medium text-muted-color">C4 — Icon escaping</span>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
          <!-- Outer wrapper provides the 20px gap above the card for the icon to escape into -->
          <div v-for="pillar in pillars" :key="pillar.title" class="escape-group relative pt-5">

            <!-- Icon box: 80px tall, 20px (25%) above the card's top edge -->
            <div class="escape-icon absolute top-0 left-1/2 -translate-x-1/2 z-10
                        flex items-center justify-center w-20 h-20 rounded-xl
                        border border-surface-700 bg-surface-900">
              <icon :name="pillar.icon" class="pillar-icon text-5xl"/>
            </div>

            <!-- Card: pt-20 = 80px gives room for the 60px of icon inside + breathing space -->
            <div class="pillar-card-escape flex flex-col items-center text-center gap-3 pt-20 pb-7 px-7
                        rounded-xl border border-surface-700 bg-surface-900 cursor-default">
              <div class="flex flex-col gap-2">
                <h3 class="font-display text-2xl font-semibold leading-tight">{{ pillar.title }}</h3>
                <p class="text-base leading-relaxed text-muted-color">{{ pillar.description }}</p>
              </div>
            </div>
          </div>
        </div>
      </section>

    </div>
  </div>
</template>

<style scoped>
/* Icon color from the selected accent */
.pillar-icon {
  color: var(--proto-accent);
  transition: transform 0.3s, filter 0.3s;
}

/* Top accent bar */
.pillar-top-bar {
  background: linear-gradient(to right, transparent, var(--proto-accent), transparent);
  opacity: 0;
  transition: opacity 0.3s;
}

/* ── C2 / C3 hover (direct card hover) ──────────────────────────── */
.pillar-card {
  transition: border-color 0.3s, box-shadow 0.3s;
}
.pillar-card:hover {
  border-color: color-mix(in srgb, var(--proto-accent) 50%, transparent);
  box-shadow: 0 0 48px -8px var(--proto-glow);
}
.pillar-card:hover .pillar-icon {
  transform: scale(1.1);
  filter: brightness(1.2);
}
.pillar-card:hover .pillar-top-bar {
  opacity: 1;
}

/* ── C4 hover (group hover on outer wrapper) ─────────────────────── */
.pillar-card-escape {
  transition: border-color 0.3s, box-shadow 0.3s;
}
.escape-group:hover .pillar-card-escape {
  border-color: color-mix(in srgb, var(--proto-accent) 50%, transparent);
  box-shadow: 0 0 48px -8px var(--proto-glow);
}
.escape-group:hover .pillar-icon {
  transform: scale(1.1);
  filter: brightness(1.2);
}
.escape-icon {
  transition: border-color 0.3s;
}
</style>
