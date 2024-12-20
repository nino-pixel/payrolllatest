import { createRouter, createWebHistory } from 'vue-router'
import LoginPage from '../components/login_page.vue'
import SignupPage from '../components/sign_up.vue'
import Dashboard from '../components/dashboard.vue'
import EmployeeManagement from '../components/employee_management.vue'
import AttendanceManagement from '../components/attendance_management.vue'
import GeneratePayroll from '../components/generate_payroll.vue'
import MarkAttendanceManually from '../components/mark_attendance_manually.vue'
import ViewPaymentHistory from '../components/view_payment_history.vue'
import SalaryAdjustment from '../components/salary_adjustment.vue'
import reports_and_analytics from '../components/reports_and_analytics.vue'
import Sidebar from '../components/Sidebar.vue'
const routes = [
  {
    path: '/login',
    name: 'Login',
    component: LoginPage,
    meta: { requiresAuth: false },
    layout: 'no-sidebar'  // Add this meta field


  },
  {
    path: '/',
    redirect: '/dashboard'
  },
  {
    path: '/signup',
    name: 'Signup',
    component: SignupPage,
    meta: { requiresAuth: false },
    layout: 'no-sidebar'  // Add this meta field


  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard,
    meta: { requiresAuth: true }

  },
  {
    path: '/employees',
    name: 'Employees',
    component: EmployeeManagement,
    meta: { requiresAuth: true }

  },
  {
    path: '/attendance',
    name: 'Attendance',
    component: AttendanceManagement,
    meta: { requiresAuth: true }

  },
  {
    path: '/generate_payroll',
    name: 'GeneratePayroll',
    component: GeneratePayroll
  },
  {
    path: '/mark_attendance_manually',
    name: 'MarkAttendanceManually',
    component: MarkAttendanceManually
  },
  {
    path: '/view_payment_history',
    name: 'ViewPaymentHistory',
    component: ViewPaymentHistory
  },
  {
    path: '/salary_adjustment',
    name: 'SalaryAdjustment',
    component: SalaryAdjustment
  },
  {
    path: '/reports_and_analytics',
    name: 'ReportsAndAnalytics',
    component: reports_and_analytics
  },


  // Add other routes here as needed
]

const router = createRouter({
  history: createWebHistory(),
  routes
})
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('token')
  
  // If route requires auth and user is not authenticated
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login')
  }
  // If trying to access login/signup while authenticated
  else if ((to.path === '/login' || to.path === '/signup') && isAuthenticated) {
    next('/dashboard')
  }
  // Otherwise proceed normally
  else {
    next()
  }
})
export default router