export interface ContactReason {
    id: string
    label: string
    order: number
}

export interface ContactMessageInsert {
    name: string
    email: string
    reason_id: string
    message: string
}