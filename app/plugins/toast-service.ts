import ToastService from 'primevue/toastservice';

export default defineNuxtPlugin(nuxt => {
    nuxt.vueApp.use(ToastService)
})