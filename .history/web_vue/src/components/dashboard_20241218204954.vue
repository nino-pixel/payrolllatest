<template>
    <DashboardLayout>
      <div class="space-y-4">
        <div class="flex justify-between items-center">
          <div>
            <h2 class="text-3xl font-bold">$6468.96</h2>
            <p class="text-muted-foreground">Current Month Earnings</p>
          </div>
          <div class="flex space-x-2">
            <Button variant="outline">Daily</Button>
            <Button variant="outline">Weekly</Button>
            <Button variant="outline">Monthly</Button>
            <Button variant="outline">Yearly</Button>
          </div>
        </div>
  
        <!-- Cards with Charts -->
        <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Card v-for="(card, index) in cards" :key="index">
            <CardHeader>
              <CardTitle>{{ card.title }}</CardTitle>
            </CardHeader>
            <CardContent>
              <div class="text-2xl font-bold">$432</div>
              <div class="h-[80px]">
                <v-chart :option="card.chartOption" autoresize />
              </div>
            </CardContent>
          </Card>
        </div>
  
        <!-- Main Charts -->
        <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
          <Card class="col-span-4">
            <CardHeader>
              <CardTitle>Overview</CardTitle>
            </CardHeader>
            <CardContent>
              <div class="h-[300px]">
                <v-chart :option="lineChartOption" autoresize />
              </div>
            </CardContent>
          </Card>
          
          <Card class="col-span-3">
            <CardHeader>
              <CardTitle>Distribution</CardTitle>
            </CardHeader>
            <CardContent>
              <div class="h-[300px]">
                <v-chart :option="pieChartOption" autoresize />
              </div>
            </CardContent>
          </Card>
        </div>
  
        <!-- Rest of your template remains the same -->
      </div>
    </DashboardLayout>
  </template>
<script>
import DashboardLayout from './layouts/DashboardLayout.vue'
import Card from './ui/Card.vue'
import CardHeader from './ui/CardHeader.vue'
import CardTitle from './ui/CardTitle.vue'
import CardContent from './ui/CardContent.vue'
import Button from './ui/Button.vue'
export default {
  data() {
    return {
      data: [
        { month: "Jan", value: 10 },
        { month: "Feb", value: 20 },
        { month: "Mar", value: 15 },
        { month: "Apr", value: 25 },
        { month: "May", value: 18 },
        { month: "Jun", value: 30 },
      ],
      cards: [
        {
          title: "Revenue Status",
          chartOption: {
            grid: {
              top: 10,
              right: 10,
              bottom: 20,
              left: 30
            },
            xAxis: { 
              type: 'category', 
              data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
              axisLine: { show: false },
              axisTick: { show: false }
            },
            yAxis: { 
              type: 'value',
              splitLine: { show: false }
            },
            series: [{
              data: [10, 15, 8, 20, 12],
              type: 'line',
              smooth: true,
              symbolSize: 6,
              lineStyle: {
                width: 2
              }
            }]
          }
        },
        // Add more cards with different chart configurations
      ],
      lineChartOption: {
        tooltip: {
          trigger: 'axis'
        },
        grid: {
          top: 20,
          right: 30,
          bottom: 20,
          left: 30
        },
        xAxis: {
          type: 'category',
          data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          axisLine: { show: false },
          axisTick: { show: false }
        },
        yAxis: {
          type: 'value',
          splitLine: {
            lineStyle: {
              type: 'dashed'
            }
          }
        },
        series: [{
          data: [10, 20, 15, 25, 18, 30],
          type: 'line',
          smooth: true,
          symbolSize: 8,
          lineStyle: {
            width: 3
          }
        }]
      },
      pieChartOption: {
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} ({d}%)'
        },
        series: [{
          type: 'pie',
          radius: '65%',
          center: ['50%', '50%'],
          data: [
            { value: 33, name: 'Facebook' },
            { value: 55, name: 'Youtube' },
            { value: 12, name: 'Direct Search' }
          ],
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          },
          label: {
            show: true,
            formatter: '{b}: {d}%'
          }
        }]
      }
    }
  }
}
</script>

<style scoped>
.echarts {
  width: 100%;
  height: 100%;
}
</style>