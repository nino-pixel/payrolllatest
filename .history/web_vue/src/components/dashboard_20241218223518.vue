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
          <div class="prediction-legend">
            <span class="prediction-dot actual"></span> Actual Data
            <span class="prediction-dot predicted"></span> Predicted Data
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
            radius: ['40%', '70%'],
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