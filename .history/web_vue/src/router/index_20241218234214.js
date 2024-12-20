import { createRouter, createWebHistory } from 'vue-router'
import LoginPage from '../components/login_page.vue'
import SignupPage from '../components/sign_up.vue'
import Dashboard from '../components/dashboard.vue'
import EmployeeManagement from '../components/employee_management.vue'
import AttendanceManagement from '../components/attendance_management.vue'

const routes = [
  {
    path: '/',
    name: 'Login',
    component: LoginPage
  },
  {
    path: '/signup',
    name: 'Signup',
    component: SignupPage
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard
  },
  {
    path: '/employees',
    name: 'Employees',
    component: EmployeeManagement
  },
  {
    path: '/attendance',
    name: 'Attendance',
    component: AttendanceManagement
  },
  {
    path: 
  }

  // Add other routes here as needed
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router