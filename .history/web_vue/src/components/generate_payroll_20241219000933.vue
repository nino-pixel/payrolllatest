<template>
    <div class="payroll-container">
      <!-- Loading Overlay -->
      <div class="loading-overlay" v-if="isLoading">
        <div class="loading-spinner"></div>
      </div>
  
      <div class="wave-bg"></div>
      <h1>Generate Payroll</h1>
  
      <!-- Employee Selection Section -->
      <div class="section employee-section">
        <div class="employee-select">
          <label>Select Employee</label>
          <select v-model="selectedEmployee" @change="loadEmployeeData">
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
          <div class="records-per-page">
            <label>Show:</label>
            <select v-model="recordsPerPage">
              <option value="10">10 entries</option>
              <option value="25">25 entries</option>
              <option value="50">50 entries</option>
              <option value="100">100 entries</option>
            </select>
          </div>
          <div class="search-box">
            <input 
              type="text" 
              v-model="searchQuery" 
              placeholder="Search records..."
              class="search-input"
            >
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
                <td>{{ record.hoursWorked }}</td>
              </tr>
            </tbody>
          </table>
        </div>
  
        <!-- Pagination -->
        <div class="pagination-controls">
          <button 
            class="pagination-btn" 
            :disabled="currentPage === 1"
            @click="currentPage--"
          >
            Previous
          </button>
          <span>Page {{ currentPage }} of {{ totalPages }}</span>
          <button 
            class="pagination-btn" 
            :disabled="currentPage === totalPages"
            @click="currentPage++"
          >
            Next
          </button>
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
              <span class="deduction-name">{{ item.name }}</span>
              <div class="tooltip" :data-tooltip="item.description">ⓘ</div>
            </div>
            <div class="deduction-amount">
              <span class="rate">{{ item.rate }}%</span>
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
      <!-- Continue with Deductions and Summary sections? -->
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
        { id: 'EMP005', name: 'David Brown', department: 'Operations', position: 'Operations Manager', baseSalary: 4800 },
        { id: 'EMP006', name: 'Emily Davis', department: 'IT', position: 'Software Engineer', baseSalary: 4000 },
        { id: 'EMP007', name: 'Michael Wilson', department: 'Sales', position: 'Sales Manager', baseSalary: 4600 },
        { id: 'EMP008', name: 'Lisa Anderson', department: 'HR', position: 'HR Specialist', baseSalary: 3800 },
        { id: 'EMP009', name: 'Robert Taylor', department: 'Finance', position: 'Accountant', baseSalary: 3900 },
        { id: 'EMP010', name: 'Jennifer Martin', department: 'Marketing', position: 'Marketing Specialist', baseSalary: 3700 }
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
        },
        {
          id: 3,
          name: 'Annual Increment',
          description: 'Yearly salary adjustment',
          type: 'percentage',
          amount: 0,
          selected: false,
          maxAmount: 5
        }
      ],

      // Incentives and Bonuses
      incentivesAndBonuses: [
        {
          id: 4,
          name: 'Performance Bonus',
          description: 'One-time bonus for exceptional performance',
          type: 'fixed',
          amount: 0,
          selected: false
        },
        {
          id: 5,
          name: 'Attendance Bonus',
          description: 'Bonus for perfect attendance',
          type: 'fixed',
          amount: 0,
          selected: false
        },
        {
          id: 6,
          name: 'Holiday Bonus',
          description: 'Special holiday compensation',
          type: 'fixed',
          amount: 0,
          selected: false
        }
      ],

      // Statutory Deductions
      statutoryDeductions: [
        {
          id: 1,
          name: 'Income Tax',
          description: 'Mandatory income tax deduction',
          type: 'percentage',
          rate: 20,
          amount: 0
        },
        {
          id: 2,
          name: 'Social Security',
          description: 'Social security contribution',
          type: 'percentage',
          rate: 6.2,
          amount: 0
        },
        {
          id: 3,
          name: 'Medicare',
          description: 'Medicare contribution',
          type: 'percentage',
          rate: 1.45,
          amount: 0
        }
      ],

      // Other Deductions
      otherDeductions: [
        {
          id: 4,
          name: 'Health Insurance',
          description: 'Optional health insurance premium',
          type: 'fixed',
          amount: 0,
          selected: false
        },
        {
          id: 5,
          name: 'Life Insurance',
          description: 'Optional life insurance premium',
          type: 'fixed',
          amount: 0,
          selected: false
        },
        {
          id: 6,
          name: 'Retirement Plan',
          description: 'Voluntary retirement contribution',
          type: 'percentage',
          amount: 0,
          selected: false
        }
      ]
    }
  },

  computed: {
    // Filtered and Paginated Records
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

    // Financial Calculations
    totalIncreases() {
      let total = 0;
      [...this.performanceIncreases, ...this.incentivesAndBonuses].forEach(item => {
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
      return parseFloat(item.amount);
    },

    calculateDeduction(item) {
      if (!this.employeeDetails) return 0;
      if (item.type === 'percentage') {
        const rate = item.rate || item.amount;
        return (this.employeeDetails.baseSalary * rate) / 100;
      }
      return parseFloat(item.amount);
    },

    // Data Loading Methods
    async loadEmployeeData() {
      try {
        this.isLoading = true;
        this.errorMessage = '';

        if (!this.selectedEmployee) {
          this.employeeDetails = null;
          this.attendanceRecords = [];
          return;
        }

        // Find employee details
        this.employeeDetails = this.employees.find(emp => emp.id === this.selectedEmployee);
        
        // Generate attendance records
        this.attendanceRecords = this.generateSampleRecords();
        
        // Calculate default deductions
        this.calculateDefaultDeductions();

        // Reset increases and custom deductions
        this.resetSelections();

      } catch (error) {
        this.errorMessage = 'Error loading employee data: ' + error.message;
        console.error('Error:', error);
      } finally {
        this.isLoading = false;
      }
    },

    // Generate sample attendance records
    generateSampleRecords() {
      const records = [];
      const statuses = ['Present', 'Late', 'Absent', 'Half-Day'];
      const startDate = new Date('2024-01-01');

      for (let i = 0; i < 100; i++) {
        const currentDate = new Date(startDate);
        currentDate.setDate(startDate.getDate() + i);
        
        // Skip weekends
        if (currentDate.getDay() === 0 || currentDate.getDay() === 6) {
          continue;
        }

        const status = statuses[Math.floor(Math.random() * statuses.length)];
        let timeIn = '08:00 AM';
        let timeOut = '05:00 PM';
        let hoursWorked = 8;

        // Adjust times based on status
        if (status === 'Late') {
          const lateMinutes = Math.floor(Math.random() * 60) + 1;
          timeIn = `${8 + Math.floor(lateMinutes/60)}:${String(lateMinutes % 60).padStart(2, '0')} AM`;
          hoursWorked = 8 - (lateMinutes/60);
        } else if (status === 'Absent') {
          timeIn = '--';
          timeOut = '--';
          hoursWorked = 0;
        } else if (status === 'Half-Day') {
          timeOut = '12:00 PM';
          hoursWorked = 4;
        }

        records.push({
          date: currentDate.toISOString().split('T')[0],
          timeIn,
          timeOut,
          status,
          hoursWorked: hoursWorked.toFixed(2)
        });
      }

      return records;
    },

    // Reset all selections
    resetSelections() {
      [...this.performanceIncreases, ...this.incentivesAndBonuses].forEach(item => {
        item.selected = false;
        item.amount = 0;
      });

      this.otherDeductions.forEach(item => {
        item.selected = false;
        item.amount = 0;
      });
    },

    // Generate final payroll
    async generatePayroll() {
      try {
        this.isLoading = true;
        this.errorMessage = '';

        const payrollData = {
          employeeId: this.selectedEmployee,
          employeeName: this.employeeDetails.name,
          department: this.employeeDetails.department,
          position: this.employeeDetails.position,
          payrollDate: new Date().toISOString(),
          baseSalary: this.employeeDetails.baseSalary,
          increases: {
            performance: this.performanceIncreases.filter(i => i.selected),
            incentives: this.incentivesAndBonuses.filter(i => i.selected)
          },
          deductions: {
            statutory: this.statutoryDeductions,
            other: this.otherDeductions.filter(d => d.selected)
          },
          totalIncreases: this.totalIncreases,
          totalDeductions: this.totalDeductions,
          netSalary: this.netSalary
        };

        // Here you would typically send this to your backend
        console.log('Generated Payroll:', payrollData);
        
        this.successMessage = 'Payroll generated successfully!';
        
        // Optional: Export to PDF or Excel
        this.exportPayroll(payrollData);

      } catch (error) {
        this.errorMessage = 'Error generating payroll: ' + error.message;
        console.error('Error:', error);
      } finally {
        this.isLoading = false;
      }
    },

    // Export payroll data
    exportPayroll(data) {
      // Implementation for exporting to PDF or Excel would go here
      console.log('Exporting payroll data:', data);
    }
  },

  // Lifecycle hooks
  mounted() {
    // Any initialization code
  },

  watch: {
    // Reset page when search changes
    searchQuery() {
      this.currentPage = 1;
    }
  }
}
</script>