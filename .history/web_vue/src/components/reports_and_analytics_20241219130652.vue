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