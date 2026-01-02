import type {UserProfileInsertData, UserProfileUpdateData} from "~/schemas/user_profile_schema";
import type {UserProfile} from "~/types/UserProfile";

export function useUserProfileService() {
    const supabase = useSupabaseClient()
    const userProfileStore = useUserProfileStore()
    const {userProfile, user} = storeToRefs(userProfileStore)
    const toast = useToast()


    async function getUserProfile(id: string): Promise<UserProfile> {
        const {data, error} = await supabase.from('user_profiles').select('*').eq('id', `${id}`)
        if (error) {
            throw error
        }
        userProfileStore.userProfile = data[0]
        return data[0]
    }

    async function updateUserProfileField({id, fieldName, value}: {
        id: string,
        fieldName: keyof UserProfileUpdateData,
        value: any
    }) {
        const {data, error} = await supabase
            .from('user_profiles')
            .update({[fieldName]: value})
            .eq('id', id).select().single()

        if (error) {
            toast.add({
                severity: 'error',
                summary: `Failed to update user profile`,
                detail: error.message,
                life: 3000,
            })
            return null
        }

        toast.add({
            severity: 'success',
            summary: `User Profile updated`,
            detail: `${fieldName} to ${data[fieldName]}`,
            life: 2000,
        })
        return await getUserProfile(id)

    }

    async function updateUserProfile(id: string, updates: UserProfileUpdateData) {
        const {error: updateError} = await supabase
            .from('user_profiles')
            .update(updates)
            .eq('id', id)

        if (updateError) {
            toast.add({
                severity: 'error',
                summary: 'Failed to Update User Profile',
                detail: updateError.message,
                life: 3000,
            })
            return null
        }

        toast.add({
            severity: 'success',
            summary: 'Updated User Profile',
            life: 3000,
        })
        return await getUserProfile(id)
    }

    async function createUserProfile(inserts: UserProfileInsertData) {
        const {data, error: updateError} = await supabase
            .from('user_profiles')
            .upsert(inserts).select().single()

        if (updateError) {
            toast.add({
                severity: 'error',
                summary: 'Failed to Update User Profile',
                detail: updateError.message,
                life: 3000,
            })
            return null
        }

        toast.add({
            severity: 'success',
            summary: 'Updated User Profile',
            life: 3000,
        })
        return await getUserProfile(data.id)
    }

    async function handleUploadAvatar(userId: string, file: File) {
        const timestamp = Date.now()
        const ext = file.name.split('.').pop()
        const filePath = `/${userId}/avatar-${timestamp}.${ext}`

        const {data: files, error: fileListError} = await supabase.storage.from('avatars').list(userId)
        if (fileListError) {
            throw fileListError
        }

        if (files) {
            const pathsToDelete = files.map(f => `${userId}/${f.name}`)
            await supabase.storage.from('avatars').remove(pathsToDelete)
        }


        const {error} = await supabase.storage
            .from('avatars')
            .upload(filePath, file, {upsert: true})
        if (error) throw error
        const {data: {publicUrl}} = await supabase.storage.from('avatars').getPublicUrl(filePath)
        await updateUserProfileField({id: userId, fieldName: 'avatar_url', value: publicUrl})

    }

    async function load() {
        if (user?.value?.id) {
            const result = await getUserProfile(user.value.id)
            if (result) {
                userProfileStore.setUserProfile(result)
            }
        }
    }

    return {
        userProfile,
        load,
        updateUserProfile,
        updateUserProfileField,
        createUserProfile,
        handleUploadAvatar
    }
}