<template>
    <div class="payroll-container">
      <!-- Loading Overlay -->
      <div class="loading-overlay" v-if="isLoading">
        <div class="loading-spinner"></div>
      </div>
  
      <div class="wave-bg"></div>
      <h1>Generate Payroll</h1>
  
      <!-- Alert Messages -->
      <div v-if="errorMessage" class="alert alert-error">
        <span class="close-btn" @click="errorMessage = ''">×</span>
        {{ errorMessage }}
      </div>
      <div v-if="successMessage" class="alert alert-success">
        <span class="close-btn" @click="successMessage = ''">×</span>
        {{ successMessage }}
      </div>
  
      <!-- Employee Selection Section -->
      <div class="section employee-section">
        <div class="employee-select">
          <label>Select Employee</label>
          <select 
            v-model="selectedEmployee" 
            @change="loadEmployeeData"
            class="purple-select"
          >
            <option value="">Choose an employee...</option>
            <option v-for="emp in employees" :key="emp.id" :value="emp.id">
              {{ emp.name }} - {{ emp.department }}
            </option>
          </select>
        </div>
  
        <!-- Employee Details Card -->
        <div class="employee-details" v-if="selectedEmployee">
          <div class="detail-item">
            <span class="label">Employee ID</span>
            <span class="value">{{ employeeDetails.id }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Department</span>
            <span class="value">{{ employeeDetails.department }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Position</span>
            <span class="value">{{ employeeDetails.position }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Base Salary</span>
            <span class="value">${{ formatCurrency(employeeDetails.baseSalary) }}/month</span>
          </div>
        </div>
      </div>
          <!-- Attendance Records Section -->
    <div class="section attendance-section" v-if="selectedEmployee">
      <h2>Attendance Records</h2>
      
      <!-- Attendance Controls -->
      <div class="attendance-controls">
        <div class="search-filter">
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Search records..."
            class="purple-input"
          >
        </div>
        <div class="records-per-page">
          <label>Show entries:</label>
          <select v-model="recordsPerPage" class="purple-select">
            <option value="10">10</option>
            <option value="25">25</option>
            <option value="50">50</option>
            <option value="100">100</option>
          </select>
        </div>
      </div>

      <!-- Attendance Table -->
      <div class="attendance-table">
        <table>
          <thead>
            <tr>
              <th>Date</th>
              <th>Time In</th>
              <th>Time Out</th>
              <th>Status</th>
              <th>Hours Worked</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="record in paginatedRecords" :key="record.date">
              <td>{{ formatDate(record.date) }}</td>
              <td>{{ record.timeIn }}</td>
              <td>{{ record.timeOut }}</td>
              <td>
                <span :class="['status-badge', record.status.toLowerCase()]">
                  {{ record.status }}
                </span>
              </td>
              <td>{{ record.hoursWorked }} hrs</td>
            </tr>
          </tbody>
          <tfoot v-if="filteredRecords.length === 0">
            <tr>
              <td colspan="5" class="no-records">No records found</td>
            </tr>
          </tfoot>
        </table>
      </div>

      <!-- Pagination -->
      <div class="pagination-controls" v-if="filteredRecords.length > 0">
        <button 
          class="pagination-btn" 
          :disabled="currentPage === 1"
          @click="currentPage--"
        >
          Previous
        </button>
        <span class="page-info">Page {{ currentPage }} of {{ totalPages }}</span>
        <button 
          class="pagination-btn" 
          :disabled="currentPage === totalPages"
          @click="currentPage++"
        >
          Next
        </button>
      </div>

      <!-- Attendance Summary -->
      <div class="attendance-summary">
        <div class="summary-card">
          <span class="label">Present Days</span>
          <span class="value">{{ presentDays }}</span>
        </div>
        <div class="summary-card">
          <span class="label">Late Days</span>
          <span class="value">{{ lateDays }}</span>
        </div>
        <div class="summary-card">
          <span class="label">Absent Days</span>
          <span class="value">{{ absentDays }}</span>
        </div>
        <div class="summary-card">
          <span class="label">Total Hours</span>
          <span class="value">{{ totalHours }} hrs</span>
        </div>
      </div>
    </div>

    <!-- Increases Section -->
    <div class="section increases-section" v-if="selectedEmployee">
      <h2>Salary Increases and Bonuses</h2>
      <div class="increases-grid">
        <!-- Performance-Based Increases -->
        <div class="increase-category">
          <h3>Performance-Based Increases</h3>
          <div class="increase-items">
            <div 
              v-for="item in performanceIncreases" 
              :key="item.id"
              class="increase-item"
            >
              <div class="increase-header">
                <label class="checkbox-label">
                  <input type="checkbox" v-model="item.selected">
                  {{ item.name }}
                </label>
                <div class="tooltip" :data-tooltip="item.description">ⓘ</div>
              </div>
              <div class="increase-inputs" v-if="item.selected">
                <input 
                  type="number" 
                  v-model="item.amount"
                  :step="item.type === 'percentage' ? 0.1 : 1"
                  :max="item.maxAmount"
                  class="purple-input"
                >
                <span class="unit">{{ item.type === 'percentage' ? '%' : '$' }}</span>
                <div class="calculated-amount">
                  = ${{ formatCurrency(calculateIncrease(item)) }}
                </div>
              </div>
            </div>
          </div>
        </div>
                <!-- Incentives and Bonuses -->
                <div class="increase-category">
          <h3>Incentives and Bonuses</h3>
          <div class="increase-items">
            <div 
              v-for="item in incentivesAndBonuses" 
              :key="item.id"
              class="increase-item"
            >
              <div class="increase-header">
                <label class="checkbox-label">
                  <input type="checkbox" v-model="item.selected">
                  {{ item.name }}
                </label>
                <div class="tooltip" :data-tooltip="item.description">ⓘ</div>
              </div>
              <div class="increase-inputs" v-if="item.selected">
                <input 
                  type="number" 
                  v-model="item.amount"
                  :step="item.type === 'percentage' ? 0.1 : 1"
                  class="purple-input"
                >
                <span class="unit">{{ item.type === 'percentage' ? '%' : '$' }}</span>
                <div class="calculated-amount">
                  = ${{ formatCurrency(calculateIncrease(item)) }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Deductions Section -->
    <div class="section deductions-section" v-if="selectedEmployee">
      <h2>Deductions</h2>
      <div class="deductions-grid">
        <!-- Statutory Deductions -->
        <div class="deduction-category">
          <h3>Statutory Deductions</h3>
          <div class="deduction-items">
            <div 
              v-for="item in statutoryDeductions" 
              :key="item.id"
              class="deduction-item"
            >
              <div class="deduction-info">
                <div class="deduction-header">
                  <span class="deduction-name">{{ item.name }}</span>
                  <div class="tooltip" :data-tooltip="item.description">ⓘ</div>
                </div>
                <div class="deduction-details">
                  Base: ${{ formatCurrency(employeeDetails?.baseSalary || 0) }}
                  <span class="calculation-formula">
                    × {{ item.rate }}% = 
                  </span>
                </div>
              </div>
              <div class="deduction-amount">
                <div class="calculated-amount negative">
                  - ${{ formatCurrency(calculateDeduction(item)) }}
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Other Deductions -->
        <div class="deduction-category">
          <h3>Other Deductions</h3>
          <div class="deduction-items">
            <div 
              v-for="item in otherDeductions" 
              :key="item.id"
              class="deduction-item"
            >
              <div class="deduction-info">
                <label class="checkbox-label">
                  <input type="checkbox" v-model="item.selected">
                  {{ item.name }}
                </label>
                <div class="tooltip" :data-tooltip="item.description">ⓘ</div>
              </div>
              <div class="deduction-inputs" v-if="item.selected">
                <input 
                  type="number" 
                  v-model="item.amount"
                  :step="item.type === 'percentage' ? 0.1 : 1"
                  class="purple-input"
                >
                <span class="unit">{{ item.type === 'percentage' ? '%' : '$' }}</span>
                <div class="calculated-amount negative">
                  - ${{ formatCurrency(calculateDeduction(item)) }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Summary Section -->
    <div class="section summary-section" v-if="selectedEmployee">
      <h2>Payroll Summary</h2>
      <div class="summary-grid">
        <div class="summary-item">
          <span class="label">Base Salary</span>
          <span class="amount">${{ formatCurrency(employeeDetails?.baseSalary || 0) }}</span>
        </div>
        <div class="summary-item">
          <span class="label">Total Increases</span>
          <span class="amount positive">+${{ formatCurrency(totalIncreases) }}</span>
        </div>
        <div class="summary-item">
          <span class="label">Total Deductions</span>
          <span class="amount negative">-${{ formatCurrency(totalDeductions) }}</span>
        </div>
        <div class="summary-item total">
          <span class="label">Net Salary</span>
          <span class="amount">${{ formatCurrency(netSalary) }}</span>
        </div>
      </div>

      <!-- Generate Button -->
      <div class="generate-section">
        <button 
          class="generate-btn" 
          @click="generatePayroll"
          :disabled="isLoading"
        >
          {{ isLoading ? 'Generating...' : 'Generate Payroll' }}
        </button>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  name: 'GeneratePayroll',
  
  data() {
    return {
      // UI States
      isLoading: false,
      errorMessage: '',
      successMessage: '',
      currentPage: 1,
      recordsPerPage: 10,
      searchQuery: '',
      
      // Employee Data
      selectedEmployee: '',
      employeeDetails: null,
      employees: [
        { id: 'EMP001', name: 'John Doe', department: 'IT', position: 'Senior Developer', baseSalary: 5000 },
        { id: 'EMP002', name: 'Jane Smith', department: 'HR', position: 'HR Manager', baseSalary: 4500 },
        { id: 'EMP003', name: 'Mike Johnson', department: 'Finance', position: 'Financial Analyst', baseSalary: 4200 },
        { id: 'EMP004', name: 'Sarah Williams', department: 'Marketing', position: 'Marketing Director', baseSalary: 5500 },
        { id: 'EMP005', name: 'David Brown', department: 'Operations', position: 'Operations Manager', baseSalary: 4800 }
      ],
      attendanceRecords: [],

      // Performance Increases
      performanceIncreases: [
        {
          id: 1,
          name: 'Merit Raise',
          description: 'Performance-based permanent increase in base salary',
          type: 'percentage',
          amount: 0,
          selected: false,
          maxAmount: 15
        },
        {
          id: 2,
          name: 'Promotion Raise',
          description: 'Salary adjustment for position promotion',
          type: 'percentage',
          amount: 0,
          selected: false,
          maxAmount: 30
        }
      ],

      // Incentives and Bonuses
      incentivesAndBonuses: [
        {
          id: 3,
          name: 'Performance Bonus',
          description: 'One-time bonus for exceptional performance',
          type: 'fixed',
          amount: 0,
          selected: false
        },
        {
          id: 4,
          name: 'Attendance Bonus',
          description: 'Perfect attendance reward: $200',
          type: 'fixed',
          amount: 200,
          selected: false
        },
        {
          id: 5,
          name: '13th Month Pay',
          description: 'Prorated 13th month pay',
          type: 'percentage',
          amount: 8.33, // 1/12 of annual salary
          selected: false
        }
      ],

      // Updated Statutory Deductions
      statutoryDeductions: [
        {
          id: 1,
          name: 'Income Tax',
          description: 'Progressive tax based on salary bracket',
          type: 'percentage',
          rate: 20,
          amount: 0
        },
        {
          id: 2,
          name: 'Social Security',
          description: 'Mandatory social security contribution',
          type: 'percentage',
          rate: 6.2,
          amount: 0
        },
        {
          id: 3,
          name: 'Medicare',
          description: 'Healthcare contribution',
          type: 'percentage',
          rate: 1.45,
          amount: 0
        },
        {
          id: 4,
          name: 'PhilHealth',
          description: 'National health insurance',
          type: 'percentage',
          rate: 2.75,
          amount: 0
        },
        {
          id: 5,
          name: 'Pag-IBIG',
          description: 'Housing development fund',
          type: 'percentage',
          rate: 2,
          amount: 0
        }
      ],

      // Other Deductions
      otherDeductions: [
        {
          id: 6,
          name: 'Health Insurance',
          description: 'Optional health insurance premium',
          type: 'fixed',
          amount: 0,
          selected: false
        },
        {
          id: 7,
          name: 'Life Insurance',
          description: 'Optional life insurance premium',
          type: 'fixed',
          amount: 0,
          selected: false
        }
      ]
    }
  },

  computed: {
    // Attendance Computations
    filteredRecords() {
      return this.attendanceRecords.filter(record => {
        const searchLower = this.searchQuery.toLowerCase();
        return (
          record.date.toLowerCase().includes(searchLower) ||
          record.status.toLowerCase().includes(searchLower)
        );
      });
    },

    paginatedRecords() {
      const start = (this.currentPage - 1) * this.recordsPerPage;
      const end = start + this.recordsPerPage;
      return this.filteredRecords.slice(start, end);
    },

    totalPages() {
      return Math.ceil(this.filteredRecords.length / this.recordsPerPage);
    },

    // Attendance Summary
    presentDays() {
      return this.attendanceRecords.filter(r => r.status === 'Present').length;
    },

    lateDays() {
      return this.attendanceRecords.filter(r => r.status === 'Late').length;
    },

    absentDays() {
      return this.attendanceRecords.filter(r => r.status === 'Absent').length;
    },

    totalHours() {
      return this.attendanceRecords.reduce((total, record) => {
        return total + parseFloat(record.hoursWorked);
      }, 0).toFixed(2);
    },

    // Financial Calculations
    totalIncreases() {
      let total = 0;
      // Calculate performance increases
      this.performanceIncreases.forEach(item => {
        if (item.selected) {
          total += this.calculateIncrease(item);
        }
      });
      // Calculate incentives and bonuses
      this.incentivesAndBonuses.forEach(item => {
        if (item.selected) {
          total += this.calculateIncrease(item);
        }
      });
      return total;
    },

    totalDeductions() {
      let total = 0;
      // Calculate statutory deductions
      this.statutoryDeductions.forEach(item => {
        total += this.calculateDeduction(item);
      });
      // Calculate other deductions
      this.otherDeductions.forEach(item => {
        if (item.selected) {
          total += this.calculateDeduction(item);
        }
      });
      return total;
    },

    netSalary() {
      const base = this.employeeDetails?.baseSalary || 0;
      return base + this.totalIncreases - this.totalDeductions;
    }
  },

  methods: {
    // Formatting Methods
    formatCurrency(value) {
      return Number(value).toFixed(2);
    },

    formatDate(dateString) {
      return new Date(dateString).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      });
    },

    // Calculation Methods
    calculateIncrease(item) {
      if (!this.employeeDetails) return 0;
      if (item.type === 'percentage') {
        return (this.employeeDetails.baseSalary * item.amount) / 100;
      }
      return parseFloat(item.amount) || 0;
    },

    calculateDeduction(item) {
      if (!this.employeeDetails) return 0;
      const baseSalary = this.employeeDetails.baseSalary;
      
      if (item.type === 'percentage') {
        const rate = item.rate || item.amount;
        return (baseSalary * rate) / 100;
      }
      return parseFloat(item.amount) || 0;
    },

    // Continue with the rest of your methods...