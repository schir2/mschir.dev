export async function useImageUpload(
    bucket: string,
    prefix: string,
    file: File,
    existingPath?: string
): Promise<string> {
    const supabaseClient = useSupabaseClient()

    const fileExtension = file.name.split('.').pop() ?? ''
    const targetPath = existingPath ?? `${prefix}/${crypto.randomUUID()}.${fileExtension}`

    const fileBuffer = await file.arrayBuffer()
    const {error: uploadError} = await supabaseClient.storage
        .from(bucket)
        .upload(targetPath, fileBuffer, {
            contentType: file.type,
            upsert: !!existingPath,
        })

    if (uploadError) {
        throw uploadError
    }

    return targetPath
}
