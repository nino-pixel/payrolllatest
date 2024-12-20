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

        this.successMessage = 'Employee data loaded successfully';

      } catch (error) {
        this.errorMessage = 'Error loading employee data: ' + error.message;
        console.error('Error:', error);
      } finally {
        this.isLoading = false;
      }
    },

    // Calculate default statutory deductions
    calculateDefaultDeductions() {
      if (!this.employeeDetails) return;

      const baseSalary = this.employeeDetails.baseSalary;
      
      // Update statutory deductions based on base salary
      this.statutoryDeductions.forEach(deduction => {
        switch(deduction.name) {
          case 'Income Tax':
            // Progressive tax calculation
            if (baseSalary <= 2500) {
              deduction.rate = 0;
            } else if (baseSalary <= 3500) {
              deduction.rate = 15;
            } else if (baseSalary <= 5000) {
              deduction.rate = 20;
            } else {
              deduction.rate = 25;
            }
            break;
          
          case 'Social Security':
            // Cap SSS contribution at maximum salary base
            const maxSalaryBase = 5000;
            deduction.amount = Math.min(baseSalary, maxSalaryBase) * (deduction.rate / 100);
            break;
          
          case 'PhilHealth':
            // Premium rate based on salary range
            if (baseSalary <= 3000) {
              deduction.rate = 2;
            } else if (baseSalary <= 4000) {
              deduction.rate = 2.5;
            } else {
              deduction.rate = 2.75;
            }
            break;
          
          // Other deductions maintain their default rates
          default:
            break;
        }
      });
    },

    // Generate sample attendance records
    generateSampleRecords() {
      const records = [];
      const statuses = ['Present', 'Late', 'Absent', 'Half-Day'];
      const startDate = new Date();
      startDate.setDate(1); // Start from beginning of current month

      // Generate records for current month
      const daysInMonth = new Date(
        startDate.getFullYear(),
        startDate.getMonth() + 1,
        0
      ).getDate();

      for (let i = 0; i < daysInMonth; i++) {
        const currentDate = new Date(startDate);
        currentDate.setDate(startDate.getDate() + i);
        
        // Skip weekends
        if (currentDate.getDay() === 0 || currentDate.getDay() === 6) {
          continue;
        }

        // Generate random status with weighted probability
        const rand = Math.random();
        let status;
        if (rand < 0.7) status = 'Present';
        else if (rand < 0.85) status = 'Late';
        else if (rand < 0.95) status = 'Half-Day';
        else status = 'Absent';

        let timeIn = '08:00 AM';
        let timeOut = '05:00 PM';
        let hoursWorked = 8;

        // Adjust times based on status
        switch(status) {
          case 'Late':
            const lateMinutes = Math.floor(Math.random() * 60) + 1;
            timeIn = `${8 + Math.floor(lateMinutes/60)}:${String(lateMinutes % 60).padStart(2, '0')} AM`;
            hoursWorked = 8 - (lateMinutes/60);
            break;
          
          case 'Absent':
            timeIn = '--';
            timeOut = '--';
            hoursWorked = 0;
            break;
          
          case 'Half-Day':
            timeOut = '12:00 PM';
            hoursWorked = 4;
            break;
        }

        records.push({
          date: currentDate.toISOString().split('T')[0],
          timeIn,
          timeOut,
          status,
          hoursWorked: hoursWorked.toFixed(2)
        });
      }

      return records.sort((a, b) => new Date(b.date) - new Date(a.date));
    },

    // Reset all selections
    resetSelections() {
      [...this.performanceIncreases, ...this.incentivesAndBonuses].forEach(item => {
        item.selected = false;
        item.amount = item.defaultAmount || 0;
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
          payrollPeriod: new Date().toLocaleDateString('en-US', {
            month: 'long',
            year: 'numeric'
          }),
          baseSalary: this.employeeDetails.baseSalary,
          attendance: {
            presentDays: this.presentDays,
            lateDays: this.lateDays,
            absentDays: this.absentDays,
            totalHours: this.totalHours
          },
          increases: {
            performance: this.performanceIncreases.filter(i => i.selected),
            incentives: this.incentivesAndBonuses.filter(i => i.selected)
          },
          deductions: {
            statutory: this.statutoryDeductions,
            other: this.otherDeductions.filter(d => d.selected)
          },
          summary: {
            totalIncreases: this.totalIncreases,
            totalDeductions: this.totalDeductions,
            netSalary: this.netSalary
          }
        };

        // Here you would typically send this to your backend
        console.log('Generated Payroll:', payrollData);
        
        this.successMessage = 'Payroll generated successfully!';
        
        // Generate PDF or Excel
        await this.exportPayroll(payrollData);

      } catch (error) {
        this.errorMessage = 'Error generating payroll: ' + error.message;
        console.error('Error:', error);
      } finally {
        this.isLoading = false;
      }
    },

    // Export payroll data
    async exportPayroll(data) {
      try {
        // Implementation for PDF/Excel export would go here
        console.log('Exporting payroll data:', data);
        
        // Simulate export delay
        await new Promise(resolve => setTimeout(resolve, 1000));
        
      } catch (error) {
        console.error('Export error:', error);
        throw new Error('Failed to export payroll data');
      }
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

<style scoped>
/* Color Variables */
:root {
  --color-purple-lightest: #f2e6ff;
  --color-purple-light: #e6ccff;
  --color-purple-medium: #cc66ff;
  --color-purple-deep: #660066;
  --color-success: #28a745;
  --color-danger: #dc3545;
  --color-warning: #ffc107;
}

/* Main Container */
.payroll-container {
  width: 100%;
  min-height: 100vh;
  padding: 20px;
  background: var(--color-purple-lightest);
  position: relative;
  overflow-x: hidden;
}

/* Wave Background */
.wave-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 150px;
  background: linear-gradient(135deg, var(--color-purple-medium), var(--color-purple-deep));
  border-radius: 0 0 50% 50%;
  z-index: 0;
}

/* Headers */
h1 {
  color: white;
  text-align: center;
  position: relative;
  z-index: 1;
  margin-bottom: 40px;
  font-size: 2.5em;
  font-weight: 600;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h2 {
  color: var(--color-purple-deep);
  margin-bottom: 20px;
  font-size: 1.8em;
  font-weight: 600;
}

h3 {
  color: var(--color-purple-deep);
  margin-bottom: 15px;
  font-size: 1.3em;
  font-weight: 500;
}

/* Section Containers */
.section {
  background: white;
  border-radius: 12px;
  padding: 25px;
  margin-bottom: 25px;
  box-shadow: 0 4px 6px rgba(102, 0, 102, 0.1);
  position: relative;
  z-index: 1;
  border: 1px solid var(--color-purple-light);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.section:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(102, 0, 102, 0.15);
}

/* Alert Messages */
.alert {
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  position: relative;
  animation: slideIn 0.3s ease;
}

.alert-error {
  background-color: #ffebee;
  color: var(--color-danger);
  border: 1px solid #ffcdd2;
}

.alert-success {
  background-color: #e8f5e9;
  color: var(--color-success);
  border: 1px solid #c8e6c9;
}

.close-btn {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  opacity: 0.7;
  transition: opacity 0.3s ease;
}

.close-btn:hover {
  opacity: 1;
}

/* Form Controls */
.purple-input,
.purple-select {
  width: 100%;
  padding: 12px;
  border: 2px solid var(--color-purple-light);
  border-radius: 8px;
  font-size: 1em;
  color: var(--color-purple-deep);
  background-color: white;
  transition: all 0.3s ease;
}

.purple-input:focus,
.purple-select:focus {
  border-color: var(--color-purple-medium);
  outline: none;
  box-shadow: 0 0 0 3px rgba(204, 102, 255, 0.2);
  background-color: var(--color-purple-lightest);
}

.purple-input::placeholder {
  color: #a880c7;
}

/* Checkbox Styling */
.checkbox-label {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  color: var(--color-purple-deep);
}

input[type="checkbox"] {
  width: 18px;
  height: 18px;
  accent-color: var(--color-purple-medium);
  cursor: pointer;
}

/* Table Styles */
.attendance-table {
  overflow-x: auto;
  margin: 20px 0;
  border-radius: 8px;
  border: 1px solid var(--color-purple-light);
}

table {
  width: 100%;
  border-collapse: collapse;
  background: white;
}

th {
  background: var(--color-purple-lightest);
  color: var(--color-purple-deep);
  padding: 15px;
  font-weight: 600;
  text-align: left;
  border-bottom: 2px solid var(--color-purple-light);
}

td {
  padding: 12px 15px;
  border-bottom: 1px solid var(--color-purple-light);
  color: var(--color-purple-deep);
}

tr:hover td {
  background-color: var(--color-purple-lightest);
}

/* Status Badges */
.status-badge {
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 0.85em;
  font-weight: 500;
  text-align: center;
  display: inline-block;
}

.status-badge.present {
  background: #e8f5e9;
  color: var(--color-success);
}

.status-badge.absent {
  background: #ffebee;
  color: var(--color-danger);
}

.status-badge.late {
  background: #fff3e0;
  color: var(--color-warning);
}

.status-badge.half-day {
  background: var(--color-purple-lightest);
  color: var(--color-purple-medium);
}

/* Summary Section */
.summary-section {
  background: white;
  padding: 30px;
  border-radius: 15px;
  border: 2px solid var(--color-purple-light);
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.summary-item {
  padding: 20px;
  background: var(--color-purple-lightest);
  border-radius: 10px;
  text-align: center;
  transition: all 0.3s ease;
  min-height: 120px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.summary-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(102, 0, 102, 0.1);
}

.summary-item .label {
  color: var(--color-purple-deep);
  font-size: 0.9em;
  margin-bottom: 10px;
}

.summary-item .amount {
  font-size: 1.4em;
  font-weight: 600;
  color: var(--color-purple-deep);
  word-break: break-word;
  padding: 0 10px;
}

.summary-item .amount.positive {
  color: var(--color-success);
}

.summary-item .amount.negative {
  color: var(--color-danger);
}

.summary-item.total {
  background: linear-gradient(135deg, var(--color-purple-medium), var(--color-purple-deep));
}

.summary-item.total .label,
.summary-item.total .amount {
  color: white;
}

/* Generate Button */
.generate-section {
  margin-top: 30px;
  text-align: center;
}

.generate-btn {
  background: linear-gradient(135deg, var(--color-purple-medium), var(--color-purple-deep));
  color: white;
  border: none;
  padding: 15px 40px;
  border-radius: 25px;
  font-size: 1.1em;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(102, 0, 102, 0.2);
}

.generate-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(102, 0, 102, 0.3);
}

.generate-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

/* Loading Overlay */
.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 4px solid var(--color-purple-light);
  border-top-color: var(--color-purple-medium);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

/* Animations */
@keyframes spin {
  to { transform: rotate(360deg); }
}

@keyframes slideIn {
  from { 
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Responsive Design */
@media (max-width: 768px) {
  .section {
    padding: 15px;
  }

  .summary-grid {
    grid-template-columns: 1fr;
  }

  .generate-btn {
    width: 100%;
    padding: 12px 20px;
  }

  .employee-section {
    flex-direction: column;
  }

  .employee-select,
  .employee-details {
    width: 100%;
  }
}
</style>