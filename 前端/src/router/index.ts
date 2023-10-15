import { createRouter, createWebHistory } from 'vue-router'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      redirect: "/login"
    },
    {
      path: "/login",
      name: "login",
      meta: { 
        requiresAuth: false
      },
      component: () => import("@/views/login.vue")
    },
    {
      path: "/:username",
      name: "admin",
      meta: { 
        requiresAuth: true 
      },
      component: () => import('@/views/admin.vue'),
      children : [
        {
          path: "summary",
          component: () => import('@/components/admin/summary.vue')
        },
        {
          path: "account",
          component: () => import('@/components/admin/accout.vue')
        },
        {
          path: "book",
          component: () => import('@/components/admin/book.vue')
        },
        {
          path: "approval",
          component: () => import('@/components/admin/approval.vue')
        }
      ],
    },
    {
      path: "/:username",
      name: "reader",
      meta: { 
        requiresAuth: true 
      },
      component: () => import('@/views/reader.vue'),
      children : [
        {
          path: "home",
          component: () => import('@/components/reader/home.vue')
        },
        {
          path: "adminlist",
          component: () => import('@/components/reader/adminlist.vue')
        },
        {
          path: "borrow",
          component: () => import('@/components/reader/borrow.vue')
        },
        {
          path: "booking",
          component: () => import('@/components/reader/booking.vue')
        }
      ],
    },
    {
      path: "/404",
      name: "404",
      meta: { 
        requiresAuth: false
      },
      component: () => import('@/components/404.vue')
    },
    {
      path: '/:pathMatch(.*)*',
      redirect: '/404',
    },
  ]
})

export default router