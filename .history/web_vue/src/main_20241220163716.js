import axios from 'axios'
import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import html2pdf from 'html2pdf.js'

// ECharts imports
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart, LineChart, BarChart, GaugeChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'

// Set base URL for API requests
axios.defaults.baseURL = 'http://localhost:8000'
axios.defaults.withCredentials = true

// Add request interceptor to include CSRF token
axios.interceptors.request.use(config => {
  const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
  if (token) {
    config.headers['X-CSRF-TOKEN'] = token
  }
  return config
})

// Add response interceptor
axios.interceptors.response.use(
  response => response,
  error => {
    if (error.response?.status === 401) {
      // Redirect to login page if unauthorized
      router.push('/login')
    }
    return Promise.reject(error)
  }
)

// Register ECharts components
use([
  CanvasRenderer,
  PieChart,
  LineChart,
  BarChart,
  GaugeChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

const app = createApp(App)

// Global error handler
app.config.errorHandler = (err, vm, info) => {
  console.error('Global error:', err)
  console.error('Component:', vm)
  console.error('Info:', info)
}

app.component('v-chart', VChart)
app.use(router)
app.mount('#app')