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
  <style scoped>
  .reports-container {
    min-height: 100vh;
    width: 100%;
    padding: 0;
    margin: 0;
    background: #f2e6ff;
    position: relative;
    overflow-x: hidden;
  }
  
  .wave-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    width: 100%;
    height: 200px;
    background: linear-gradient(135deg, #cc66ff, #660066);
    border-radius: 0 0 50% 50%;
    z-index: 1; /* Reduced z-index */
}
  
  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 2rem;
  }
  
  /* Header Styles */
  .header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
  }
  
  .header-section h1 {
    color: white;
    font-size: 1.8rem;
    margin: 0;
  }
  
  .date-filter {
    display: flex;
    gap: 1rem;
  }
  
  .purple-select {
    padding: 0.5rem 1rem;
    border: 2px solid #e6ccff;
    border-radius: 8px;
    background: white;
    color: #660066;
    cursor: pointer;
  }
  
  /* Overview Card Styles */
  .overview-card {
    background: white;
    border-radius: 10px;
    padding: 1.5rem;
    margin-bottom: 2rem;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }
  
  .overview-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin-top: 1rem;
  }
  
  .overview-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: 1rem;
    background: #f8f4ff;
    border-radius: 8px;
  }
  
  .overview-item .label {
    color: #666;
    font-size: 0.9rem;
    margin-bottom: 0.5rem;
  }
  
  .overview-item .value {
    color: #660066;
    font-size: 1.5rem;
    font-weight: bold;
  }
  
  /* Reports Grid Styles */
  .reports-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    gap: 2rem;
    margin-bottom: 2rem;
  }
  
  .report-card {
    background: white;
    border-radius: 10px;
    padding: 1.5rem;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }
  
  .report-card h3 {
    color: #660066;
    margin-bottom: 1.5rem;
  }
  
  /* Attendance Stats */
  .attendance-stats {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1rem;
    margin-top: 1rem;
  }
  
  .stat-item {
    text-align: center;
    padding: 0.5rem;
  }
  
  .stat-item .label {
    color: #666;
    font-size: 0.9rem;
  }
  
  .stat-item .value {
    color: #660066;
    font-weight: bold;
  }
  
  /* Performance Metrics */
  .performance-metrics {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
  }
  
  .metric {
    width: 100%;
  }
  
  .metric-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 0.5rem;
    color: #666;
  }
  
  .progress-bar {
    width: 100%;
    height: 8px;
    background: #e6ccff;
    border-radius: 4px;
    overflow: hidden;
  }
  
  .progress {
    height: 100%;
    background: linear-gradient(90deg, #cc66ff, #660066);
    transition: width 0.3s ease;
  }
  
  /* Tax Report Styles */
  .tax-report-card {
    background: white;
    border-radius: 10px;
    padding: 1.5rem;
    margin-top: 2rem;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }
  
  .tax-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    gap: 2rem;
    margin-top: 1.5rem;
  }
  
  .tax-section h4 {
    color: #660066;
    margin-bottom: 1rem;
  }
  
  /* Tax Table Styles */
  .tax-table table {
    width: 100%;
    border-collapse: collapse;
  }
  
  .tax-table th,
  .tax-table td {
    padding: 0.8rem;
    text-align: left;
    border-bottom: 1px solid #e6ccff;
  }
  
  .tax-table th {
    background: #f8f4ff;
    color: #660066;
    font-weight: 600;
  }
  
  /* Deductions Summary */
  .deductions-summary {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 1rem;
    margin-top: 1rem;
  }
  
  .deduction-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: 0.8rem;
    background: #f8f4ff;
    border-radius: 8px;
  }
  
  .deduction-item .label {
    color: #666;
    font-size: 0.9rem;
    margin-bottom: 0.3rem;
  }
  
  .deduction-item .value {
    color: #660066;
    font-weight: bold;
  }
  
  /* Responsive Styles */
  @media (max-width: 768px) {
    .content-wrapper {
      padding: 1rem;
    }
  
    .header-section {
      flex-direction: column;
      gap: 1rem;
      text-align: center;
    }
  
    .reports-grid,
    .tax-grid {
      grid-template-columns: 1fr;
    }
  
    .overview-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  
    .attendance-stats {
      grid-template-columns: 1fr;
    }
  
    .deductions-summary {
      grid-template-columns: repeat(2, 1fr);
    }
  }
  
  /* Chart Container Styles */
  canvas {
    width: 100% !important;
    height: 300px !important;
    margin: 1rem 0;
  }
  h2, td,h3{
    color:#660066
  }
  </style>