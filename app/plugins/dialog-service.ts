import DialogService from 'primevue/dialogservice'
import DynamicDialog from 'primevue/dynamicdialog'

export default defineNuxtPlugin(nuxt => {
    nuxt.vueApp.use(DialogService)
    nuxt.vueApp.component('DynamicDialog', DynamicDialog)
})
