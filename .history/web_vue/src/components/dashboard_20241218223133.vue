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
                  series: [
          {
            name: 'HR',
            type: 'line',
            data: [90, 56, 47, 36, 77, 96, 92, 88, 85, 87, 89, 91],
            lineStyle: {
              width: 2,
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 1,
                y2: 0,
                colorStops: [{
                  offset: 0.4,
                  color: '#FF6B6B'
                }, {
                  offset: 0.6,
                  color: '#FFB6B6'
                }]
              }
            },
            itemStyle: {
              color: function(params) {
                return params.dataIndex >= 6 ? '#FFB6B6' : '#FF6B6B';
              }
            }
          },
          {
            name: 'IT',
            type: 'line',
            data: [24, 65, 75, 57, 34, 34, 45, 50, 55, 58, 60, 62],
            lineStyle: {
              width: 2,
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 1,
                y2: 0,
                colorStops: [{
                  offset: 0.4,
                  color: '#4ECDC4'
                }, {
                  offset: 0.6,
                  color: '#A8E6E2'
                }]
              }
            },
            itemStyle: {
              color: function(params) {
                return params.dataIndex >= 6 ? '#A8E6E2' : '#4ECDC4';
              }
            }
          },
          {
            name: 'Finance',
            type: 'line',
            data: [81, 100, 84, 85, 83, 84, 85, 86, 87, 88, 89, 90],
            lineStyle: {
              width: 2,
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 1,
                y2: 0,
                colorStops: [{
                  offset: 0.4,
                  color: '#FFB347'
                }, {
                  offset: 0.6,
                  color: '#FFD7A8'
                }]
              }
            },
            itemStyle: {
              color: function(params) {
                return params.dataIndex >= 6 ? '#FFD7A8' : '#FFB347';
              }
            }
          },
          {
            name: 'Marketing',
            type: 'line',
            data: [93, 92, 91, 93, 94, 95, 94, 93, 95, 94, 96, 95],
            lineStyle: {
              width: 2,
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 1,
                y2: 0,
                colorStops: [{
                  offset: 0.4,
                  color: '#9B59B6'
                }, {
                  offset: 0.6,
                  color: '#D2B4DE'
                }]
              }
            },
            itemStyle: {
              color: function(params) {
                return params.dataIndex >= 6 ? '#D2B4DE' : '#9B59B6';
              }
            }
          },
          {
            name: 'Operations',
            type: 'line',
            data: [91, 90, 92, 93, 91, 94, 93, 92, 94, 95, 93, 96],
            lineStyle: {
              width: 2,
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 1,
                y2: 0,
                colorStops: [{
                  offset: 0.4,
                  color: '#3498DB'
                }, {
                  offset: 0.6,
                  color: '#A9CCE3'
                }]
              }
            },
            itemStyle: {
              color: function(params) {
                return params.dataIndex >= 6 ? '#A9CCE3' : '#3498DB';
              }
            }
          }
        ],
        graphic: [{
          type: 'rect',
          z: -1,
          left: '45%',
          top: 'center',
          shape: {
            width: '55%',
            height: '100%'
          },
          style: {
            fill: 'rgba(250, 250, 250, 0.3)'
          }
        }]
      },

      payrollBatteryOption: {
        // ... existing payrollBatteryOption configuration ...
      }
    }
  },
  methods: {
    calculatePredictions(historicalData) {
      // Implement your prediction logic here
      return historicalData.map(value => {
        const randomVariation = (Math.random() - 0.5) * 5; // ±2.5% variation
        return Math.min(100, Math.max(0, value + randomVariation));
      });
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
  overflow-x: hidden;
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
  position: relative;
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

.prediction-legend {
  position: absolute;
  bottom: 10px;
  right: 10px;
  background: rgba(255, 255, 255, 0.9);
  padding: 8px 12px;
  border-radius: 4px;
  font-size: 0.8em;
  color: #666;
  display: flex;
  align-items: center;
  gap: 15px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.prediction-dot {
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-right: 5px;
}

.prediction-dot.actual {
  background: #FF6B6B;
}

.prediction-dot.predicted {
  background: #FFB6B6;
}

/* Make charts responsive */
.echarts {
  width: 100%;
  height: 100%;
  min-height: 300px;
}

@media (max-width: 768px) {
  .charts-grid {
    grid-template-columns: 1fr;
  }

  .chart-card.wide {
    grid-column: auto;
  }

  .chart-container {
    height: 250px;
  }
}
</style>