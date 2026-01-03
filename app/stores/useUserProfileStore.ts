import {UserProfile} from "/types/UserProfile";

export const useUserProfileStore = defineStore('user-profile', () => {
    const userProfile = ref<UserProfile>()
    const user = useSupabaseUser()

    function setUserProfile(updateUserProfile: UserProfile) {
        userProfile.value = updateUserProfile
    }

    return {userProfile, user, setUserProfile}
})