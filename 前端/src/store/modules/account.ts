import { defineStore } from 'pinia'

const useAccountStore = defineStore("account", {
    state: () => ({
        userNumber: '',
        username: '',
        userType: '',
        isLogin: false,
        isInfoComplete: false,
    }),

    getters: {

    },

    actions: {

    }
})



export default useAccountStore