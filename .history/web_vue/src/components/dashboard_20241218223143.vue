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
          // ... existing departmentBarOption configuration ...
        },
  
        salaryPieOption: {
          // ... existing salaryPieOption configuration ...
        },
  
        attendanceLineOption: {
          title: {
            text: 'Monthly Attendance Rate with Predictions',
            left: 'center'
          },
          tooltip: {
            trigger: 'axis',
            formatter: function(params) {
              let tooltip = params[0].axisValue + '<br/>';
              params.forEach(param => {
                const isPredicted = param.dataIndex >= 6;
                const value = param.value;
                const confidence = isPredicted ? '±3%' : '';
                tooltip += `
                  <span style="display:inline-block;width:10px;height:10px;background:${param.color};margin-right:5px;"></span>
                  ${param.seriesName}${isPredicted ? ' (Predicted)' : ''}: ${value}% ${confidence}<br/>
                `;
              });
              return tooltip;
            }
          },
          legend: {
            top: '5%',
            textStyle: {
              fontSize: 10
            }
          },
          grid: {
            top: '15%',
            right: '3%',
            bottom: '10%',
            left: '10%',
            containLabel: true
          },
          xAxis: {
            type: 'category',
            data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            axisLabel: {
              formatter: function(value, index) {
                return index >= 6 ? `${value}\n(Pred)` : value;
              },
              color: function(value, index) {
                return index >= 6 ? '#888888' : '#333333';
              }
            }
          },
          yAxis: {
            type: 'value',
            name: 'Attendance Rate (%)',
            max: 100,
            min: 0
          },
          