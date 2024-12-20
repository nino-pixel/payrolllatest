<template>
    <div class="dashboard-container">
      <div class="wave-bg"></div>
      <h1>PayrollEmp Dashboard</h1>
      
      <div class="charts-grid">
        <!-- Employee Population Bar Graph -->
        <div class="chart-card">
          <h2>Employee Population by Department</h2>
          <div class="chart-container">
            <v-chart :option="departmentBarOption" autoresize />
          </div>
        </div>
  
        <!-- Salary Distribution Pie Chart -->
        <div class="chart-card">
          <h2>Salary Distribution</h2>
          <div class="chart-container">
            <v-chart :option="salaryPieOption" autoresize />
          </div>
        </div>
  
        <!-- Attendance Line Chart -->
        <div class="chart-card wide">
          <h2>Monthly Attendance Summary</h2>
          <div class="chart-container">
            <v-chart :option="attendanceLineOption" autoresize />
          </div>
        </div>
  
        <!-- Payroll Countdown Battery Chart -->
        <div class="chart-card">
          <h2>Payroll Countdown</h2>
          <div class="chart-container">
            <v-chart :option="payrollBatteryOption" autoresize />
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'Dashboard',
    data() {
      return {
        departmentBarOption: {
          title: {
            text: 'Employee Count by Department',
            left: 'center'
          },
          grid: {
    top: '15%',
    right: '3%',
    bottom: '10%',
    left: '10%',
    containLabel: true
  },
          tooltip: {
            trigger: 'axis',
            axisPointer: {
              type: 'shadow'
            }
          },
          xAxis: {
            type: 'category',
            data: ['HR', 'IT', 'Finance', 'Marketing', 'Operations'],
            axisLabel: {
              interval: 0,
              rotate: 30
            }
          },
          yAxis: {
            type: 'value',
            name: 'Number of Employees'
          },
          series: [{
            data: [30, 45, 25, 35, 40],
            type: 'bar',
            barWidth: '60%',
            itemStyle: {
              color: '#6b2c91'
            }
          }]
        },
  
        salaryPieOption: {
          title: {
            text: 'Salary Distribution',
            left: 'center'
          },
          tooltip: {
            trigger: 'item',
            formatter: '{b}: ${c}K ({d}%)'
          },
          series: [{
            type: 'pie',
            radius: ['40%', '70%'], // Make it a donut chart for better space usage
            data: [
              { value: 150, name: 'HR' },
              { value: 200, name: 'IT' },
              { value: 180, name: 'Finance' },
              { value: 120, name: 'Marketing' },
              { value: 160, name: 'Operations' }
            ],
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }]
        },
  
        attendanceLineOption: {
          title: {
            text: 'Monthly Attendance Rate',
            left: 'center'
          },
          tooltip: {
            trigger: 'axis'
          },
          legend: {
            data: ['HR', 'IT', 'Finance', 'Marketing', 'Operations'],
            top: 30
          },
          grid: {
    top: '15%',
    right: '3%',
    bottom: '10%',
    left: '10%',
    containLabel: true
  },
  legend: {
    top: '5%',
    textStyle: {
      fontSize: 10
    }
  },
          xAxis: {
            type: 'category',
            data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
          },
          yAxis: {
            type: 'value',
            name: 'Attendance Rate (%)',
            max: 100
          },
          series: [
            {
              name: 'HR',
              type: 'line',
              data: [95, 93, 94, 95, 92, 96]
            },
            {
              name: 'IT',
              type: 'line',
              data: [92, 94, 93, 91, 93, 95]
            },
            {
              name: 'Finance',
              type: 'line',
              data: [90, 91, 92, 94, 93, 92]
            },
            {
              name: 'Marketing',
              type: 'line',
              data: [93, 92, 91, 93, 94, 95]
            },
            {
              name: 'Operations',
              type: 'line',
              data: [91, 90, 92, 93, 91, 94]
            }
          ]
        },
  
        payrollBatteryOption: {
          title: {
            text: 'Days Until Next Payroll',
            left: 'center'
          },
          series: [{
            type: 'gauge',
    center: ['50%', '60%'],
    radius: '80%',

            startAngle: 180,
            endAngle: 0,
            min: 0,
            max: 15,
            splitNumber: 3,
            progress: {
              show: true,
              roundCap: true,
              width: 18
            },
            pointer: {
              show: false
            },
            axisLine: {
              roundCap: true,
              lineStyle: {
                width: 18
              }
            },
            axisTick: {
              show: false
            },
            splitLine: {
              show: false
            },
            axisLabel: {
              show: false
            },
            title: {
              show: false
            },
            detail: {
              valueAnimation: true,
              offsetCenter: [0, '0%'],
              fontSize: 30,
              formatter: '{value} days',
            },
            data: [{
              value: 7
            }]
          }]
        }
      }
    }
  }
  </script>
  
  <style scoped>
  .dashboard-container {
    width: 100vw;
    min-height: 100vh;
    padding: 20px;
    background: white;
    position: relative;
  overflow: hidden;
  }
  
  .wave-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 150px;
    background: linear-gradient(135deg, #6b2c91, #4a1f64);
    border-radius: 0 0 50% 50%;
    z-index: 0;
  }
  
  h1 {
    color: white;
    text-align: center;
    position: relative;
    z-index: 1;
    margin-bottom: 40px;
  }
  
  .charts-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
    padding: 20px;
    position: relative;
    z-index: 1;
  }
  
  .chart-card {
    background: white;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  
  .chart-card.wide {
    grid-column: span 2;
  }
  
  .chart-container {
    height: 300px;
    width: 100%;
  }
  
  h2 {
    color: #4a1f64;
    margin-bottom: 20px;
    font-size: 1.2em;
  }
  
  /* Make charts responsive */
  .echarts {
    width: 100%;
    height: 100%;
    min-height: 300px;
  }
  </style>