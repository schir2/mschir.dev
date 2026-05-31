import type { Skill } from '#shared/types/Skill'

export type SkillSnapshot = Pick<Skill, 'id' | 'name' | 'icon'>
