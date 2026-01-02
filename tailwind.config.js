/** @type {import('tailwindcss').Config} */
import PrimeUI from 'tailwindcss-primeui';

function withOpacity(variableName) {
    return ({opacityValue}) => {
        if (opacityValue !== undefined) {
            return `rgba(var(--${variableName}), ${opacityValue})`
        }
        return `rgb(var(--${variableName}))`
    }
}


export default {
  content: [],
  theme: {
    extend: {

        minHeight: {
            'nav-offset': 'calc(100vh - 5rem)',
        }
    },
  },
  plugins: [
      PrimeUI,
      require('@tailwindcss/typography')
  ],
}

