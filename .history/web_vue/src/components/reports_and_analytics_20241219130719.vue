<template>
    <div class="reports-container">
      <div class="wave-bg"></div>
      
      <div class="content-wrapper">
        <!-- Header Section -->
        <div class="header-section">
          <h1>Reports & Analytics</h1>
          <div class="date-filter">
            <select v-model="selectedYear" class="purple-select">
              <option v-for="year in years" :key="year" :value="year">
                {{ year }}
              </option>
            </select>
            <select v-model="selectedMonth" class="purple-select">
              <option v-for="month in months" :key="month" :value="month">
                {{ month }}
              </option>
            </select>
          </div>
        </div>
  
        <!-- Payroll Overview Card -->
        <div class="overview-card">
          <h2>Payroll Overview</h2>
          <div class="overview-grid">
            <div class="overview-item">
              <span class="label">Total Payroll</span>
              <span class="value">₱{{ formatCurrency(payrollData.totalPayroll) }}</span>
            </div>
            <div class="overview-item">
              <span class="label">Total Employees</span>
              <span class="value">{{ payrollData.totalEmployees }}</span>
            </div>
            <div class="overview-item">
              <span class="label">Average Salary</span>
              <span class="value">₱{{ formatCurrency(payrollData.averageSalary) }}</span>
            </div>
            <div class="overview-item">
              <span class="label">Total Deductions</span>
              <span class="value">₱{{ formatCurrency(payrollData.totalDeductions) }}</span>
            </div>
          </div>
        </div>
  
        <!-- Reports Grid -->
        <div class="reports-grid">
          <!-- Attendance Report -->
          <div class="report-card">
            <h3>Attendance Report</h3>
            <canvas ref="attendanceChart"></canvas>
            <div class="attendance-stats">
              <div class="stat-item">
                <span class="label">Present</span>
                <span class="value">{{ attendanceData.presentPercentage }}%</span>
              </div>
              <div class="stat-item">
                <span class="label">Absent</span>
                <span class="value">{{ attendanceData.absentPercentage }}%</span>
              </div>
              <div class="stat-item">
                <span class="label">Leave</span>
                <span class="value">{{ attendanceData.leavePercentage }}%</span>
              </div>
            </div>
          </div>
  
          <!-- Employee Performance -->
          <div class="report-card">
            <h3>Employee Performance</h3>
            <div class="performance-metrics">
              <div class="metric">
                <div class="metric-header">
                  <span>Attendance Compliance</span>
                  <span>{{ performanceData.attendanceCompliance }}%</span>
                </div>
                <div class="progress-bar">
                  <div 
                    class="progress" 
                    :style="{ width: performanceData.attendanceCompliance + '%' }"
                  ></div>
                </div>
              </div>
              <div class="metric">
                <div class="metric-header">
                  <span>Punctuality</span>
                  <span>{{ performanceData.punctuality }}%</span>
                </div>
                <div class="progress-bar">
                  <div 
                    class="progress" 
                    :style="{ width: performanceData.punctuality + '%' }"
                  ></div>
                </div>
              </div>
              <div class="metric">
                <div class="metric-header">
                  <span>Efficiency</span>
                  <span>{{ performanceData.efficiency }}%</span>
                </div>
                <div class="progress-bar">
                  <div 
                    class="progress" 
                    :style="{ width: performanceData.efficiency + '%' }"
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
  
        <!-- Tax Report -->
        <div class="tax-report-card">
          <h3>Tax Report</h3>
          <div class="tax-grid">
            <!-- Income Tax Brackets -->
            <div class="tax-section">
              <h4>Income Tax Brackets</h4>
              <div class="tax-table">
                <table>
                  <thead>
                    <tr>
                      <th>Bracket</th>
                      <th>Range</th>
                      <th>Employees</th>
                      <th>Percentage</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="bracket in taxData.brackets" :key="bracket.id">
                      <td>{{ bracket.name }}</td>
                      <td>₱{{ formatCurrency(bracket.range) }}</td>
                      <td>{{ bracket.employees }}</td>
                      <td>{{ bracket.percentage }}%</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
  
            <!-- Statutory Deductions -->
            <div class="tax-section">
              <h4>Statutory Deductions</h4>
              <div class="deductions-chart">
                <canvas ref="deductionsChart"></canvas>
              </div>
              <div class="deductions-summary">
                <div class="deduction-item" v-for="item in taxData.deductions" :key="item.type">
                  <span class="label">{{ item.type }}</span>
                  <span class="value">₱{{ formatCurrency(item.amount) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  <script>
  import { Chart, registerables } from 'chart.js'
  Chart.register(...registerables)
  
  export default {
    name: 'ReportsAndAnalytics',
    data() {
      return {
        selectedYear: new Date().getFullYear(),
        selectedMonth: new Date().toLocaleString('default', { month: 'long' }),
        years: [2023, 2024, 2025],
        months: [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ],
        
        // Payroll Overview Data
        payrollData: {
          totalPayroll: 1250000,
          totalEmployees: 45,
          averageSalary: 27777.78,
          totalDeductions: 187500
        },
  
        // Attendance Data
        attendanceData: {
          presentPercentage: 92,
          absentPercentage: 3,
          leavePercentage: 5,
          monthlyData: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [
              {
                label: 'Present',
                data: [95, 92, 88, 94, 91, 92],
                borderColor: '#4CAF50',
                tension: 0.4
              },
              {
                label: 'Absent',
                data: [2, 3, 5, 2, 4, 3],
                borderColor: '#f44336',
                tension: 0.4
              },
              {
                label: 'Leave',
                data: [3, 5, 7, 4, 5, 5],
                borderColor: '#2196F3',
                tension: 0.4
              }
            ]
          }
        },
  
        // Performance Data
        performanceData: {
          attendanceCompliance: 95,
          punctuality: 88,
          efficiency: 92
        },
  
        // Tax Report Data
        taxData: {
          brackets: [
            {
              id: 1,
              name: '0%',
              range: '0 - 250,000',
              employees: 15,
              percentage: 33.33
            },
            {
              id: 2,
              name: '20%',
              range: '250,001 - 400,000',
              employees: 20,
              percentage: 44.44
            },
            {
              id: 3,
              name: '25%',
              range: '400,001 - 800,000',
              employees: 8,
              percentage: 17.78
            },
            {
              id: 4,
              name: '30%',
              range: '800,001 - 2,000,000',
              employees: 2,
              percentage: 4.45
            }
          ],
          deductions: [
            { type: 'SSS', amount: 45000, percentage: 35 },
            { type: 'PhilHealth', amount: 32000, percentage: 25 },
            { type: 'Pag-IBIG', amount: 25000, percentage: 20 },
            { type: 'Withholding Tax', amount: 85500, percentage: 20 }
          ]
        }
      }
    },
  
    mounted() {
      this.initializeCharts()
    },
  
    methods: {
      formatCurrency(value) {
        return Number(value).toLocaleString('en-PH', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        })
      },
  
      initializeCharts() {
        // Attendance Line Chart
        const attendanceCtx = this.$refs.attendanceChart.getContext('2d')
        new Chart(attendanceCtx, {
          type: 'line',
          data: this.attendanceData.monthlyData,
          options: {
            responsive: true,
            plugins: {
              legend: {
                position: 'bottom'
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                max: 100
              }
            }
          }
        })
  
        // Deductions Pie Chart
        const deductionsCtx = this.$refs.deductionsChart.getContext('2d')
        new Chart(deductionsCtx, {
          type: 'pie',
          data: {
            labels: this.taxData.deductions.map(d => d.type),
            datasets: [{
              data: this.taxData.deductions.map(d => d.percentage),
              backgroundColor: [
                '#4CAF50',
                '#2196F3',
                '#FFC107',
                '#9C27B0'
              ]
            }]
          },
          options: {
            responsive: true,
            plugins: {
              legend: {
                position: 'bottom'
              }
            }
          }
        })
      },
  
      updateReports() {
        // Method to update reports when year/month changes
        // You would typically make an API call here
        console.log('Updating reports for:', this.selectedMonth, this.selectedYear)
      }
    },
  
    watch: {
      selectedMonth() {
        this.updateReports()
      },
      selectedYear() {
        this.updateReports()
      }
    }
  }
  </script>