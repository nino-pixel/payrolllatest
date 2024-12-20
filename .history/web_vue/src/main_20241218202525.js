import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js';
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);
import ECharts from 'vue-echarts';
import Highcharts from 'highcharts';
import Chart from 'chart.js/auto';


import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

const app = createApp(App)
app.component('v-chart', ECharts);
app.use(router)
app.mount('#app')
