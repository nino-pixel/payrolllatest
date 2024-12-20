<template>
  <!-- Previous template code remains the same -->
</template>

<script>
export default {
  name: 'Dashboard',
  data() {
    return {
      // ... other options remain the same ...

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
              // Add (Predicted) tag for predicted values
              const isPredicted = param.dataIndex >= 6; // Assuming first 6 months are actual data
              const value = param.value;
              const label = isPredicted ? `${param.seriesName} (Predicted)` : param.seriesName;
              tooltip += `${label}: ${value}%<br/>`;
            });
            return tooltip;
          }
        },
        legend: {
          top: '5%',
          textStyle: {
            fontSize: 10
          },
          data: ['HR', 'IT', 'Finance', 'Marketing', 'Operations', 'Prediction Range']
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
          data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'],
          axisLabel: {
            formatter: function(value, index) {
              return index >= 6 ? value + ' (Pred)' : value;
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
            data: [90, 56, 47, 36, 77, 96, 92, 88, 85], // Last 3 are predictions
            lineStyle: {
              width: 2
            },
            itemStyle: {
              color: '#5470c6'
            },
            markArea: {
              silent: true,
              itemStyle: {
                color: 'rgba(84, 112, 198, 0.1)'
              },
              data: [
                [{
                  xAxis: 'Jul'
                }, {
                  xAxis: 'Sep'
                }]
              ]
            }
          },
          {
            name: 'IT',
            type: 'line',
            data: [24, 65, 75, 57, 34, 34, 45, 50, 55], // Last 3 are predictions
            lineStyle: {
              width: 2
            },
            itemStyle: {
              color: '#91cc75'
            }
          },
          {
            name: 'Finance',
            type: 'line',
            data: [81, 100, 84, 85, 83, 84, 85, 86, 87], // Last 3 are predictions
            lineStyle: {
              width: 2
            },
            itemStyle: {
              color: '#fac858'
            }
          },
          {
            name: 'Marketing',
            type: 'line',
            data: [93, 92, 91, 93, 94, 95, 94, 93, 95], // Last 3 are predictions
            lineStyle: {
              width: 2
            },
            itemStyle: {
              color: '#ee6666'
            }
          },
          {
            name: 'Operations',
            type: 'line',
            data: [91, 90, 92, 93, 91, 94, 93, 92, 94], // Last 3 are predictions
            lineStyle: {
              width: 2
            },
            itemStyle: {
              color: '#73c0de'
            }
          },
          {
            name: 'Prediction Range',
            type: 'line',
            markArea: {
              silent: true,
              itemStyle: {
                color: 'rgba(250, 200, 88, 0.1)'
              },
              data: [[{
                xAxis: 'Jul',
                yAxis: 'min'
              }, {
                xAxis: 'Sep',
                yAxis: 'max'
              }]]
            }
          }
        ],
        visualMap: {
          show: false,
          pieces: [{
            gt: 5,
            lt: 9,
            color: '#f4f4f4'
          }]
        }
      },

      // ... other options remain the same ...
    }
  },
  methods: {
    // Add method to calculate predictions
    calculatePredictions(historicalData) {
      // Simple linear regression could be implemented here
      // For now, we're using mock predictions
      return historicalData.map(value => value * 1.1);
    }
  }
}
</script>

<style scoped>
/* Previous styles remain the same */

/* Add styles for prediction indicators */
.prediction-indicator {
  display: inline-block;
  padding: 2px 6px;
  background: rgba(250, 200, 88, 0.2);
  border-radius: 4px;
  font-size: 0.8em;
  margin-left: 8px;
}

.chart-card {
  /* ... existing styles ... */
  position: relative;
}

.prediction-legend {
  position: absolute;
  bottom: 10px;
  right: 10px;
  background: rgba(255, 255, 255, 0.9);
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 0.8em;
  color: #666;
}
</style>