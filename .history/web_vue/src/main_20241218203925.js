import ECharts from 'vue-echarts';
import Highcharts from 'highcharts';
import Chart from 'chart.js/auto';
import VueChart from 'vue-chartjs';




const app = createApp(App)
app.component('v-chart', ECharts);
app.component('v-chart', Highcharts);
app.component('v-chart', Chart);
app.component('v-chart', VueChart);
app.use(router)
app.mount('#app')
