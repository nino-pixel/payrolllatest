import { createRouter, createWebHistory } from 'vue-router'
import LoginPage from '../components/login_page.vue'
import SignupPage from '../components/sign_up.vue'


const routes = [
  {
    path: '/',
    name: 'Login',
    component: LoginPage
  }
  // Add other routes here as needed
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router