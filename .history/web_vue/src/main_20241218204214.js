import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

// ECharts imports
import VChart from 'vue-echarts'
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart, LineChart, BarChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'

// Register ECharts components
use([
  CanvasRenderer,
  PieChart,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

const app = createApp(App)
app.component('v-chart', VChart) // Register v-chart component globally
app.use(router)
app.mount('#app')