import { MdEditor, MdPreview, MdCatalog, config } from 'md-editor-v3'
import 'md-editor-v3/lib/style.css'
import katex from 'katex'
import 'katex/dist/katex.css'
import mermaid from 'mermaid'

config({
  editorExtensions: {
    katex: { instance: katex },
    mermaid: { instance: mermaid },
  },
})

export default defineNuxtPlugin((nuxt) => {
  nuxt.vueApp.component('MdEditor', MdEditor)
  nuxt.vueApp.component('MdPreview', MdPreview)
  nuxt.vueApp.component('MdCatalog', MdCatalog)
})
