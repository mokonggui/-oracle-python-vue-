import { createApp } from 'vue'
import App from './App.vue'
import router from './router'


import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

import pinia from './store'

const app = createApp(App)

//全局导入elemnt-plus的图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component)
}
app.use(pinia)
app.use(router)
app.use(ElementPlus)

app.mount('#app')


//路由守卫
import useAccountStore from './store/modules/account'
const accountStore = useAccountStore()

router.beforeEach((to, from, next) => {
    if(to.meta.requiresAuth == true){
        if (accountStore.isLogin) {
            next() // 已登录
        } else {
            next({ path:"/login" }) //跳到登陆页面
        }
    } else {
        next() //放行
    }
})