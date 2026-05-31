import ConfirmationService from 'primevue/confirmationservice'

export default defineNuxtPlugin((nuxt) => {
  nuxt.vueApp.use(ConfirmationService)
})
