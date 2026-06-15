import { readdirSync } from 'fs'
import { join } from 'path'

export default defineEventHandler(() => {
  const heroDir = join(process.cwd(), 'public/img/heroes')
  return readdirSync(heroDir).filter(file => /\.(png|jpg|jpeg|webp)$/i.test(file))
})
