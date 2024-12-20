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
import
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
  }

  // Add other routes here as needed
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router