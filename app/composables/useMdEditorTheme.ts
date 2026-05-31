export function useMdEditorTheme() {
  const isDark = ref(false)

  onMounted(() => {
    isDark.value = document.documentElement.classList.contains('dark-mode')

    const observer = new MutationObserver(() => {
      isDark.value = document.documentElement.classList.contains('dark-mode')
    })
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['class'] })
    onUnmounted(() => observer.disconnect())
  })

  return computed<'dark' | 'light'>(() => (isDark.value ? 'dark' : 'light'))
}
