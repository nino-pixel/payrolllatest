<template>
    <div class="payroll-container">
      <!-- Loading Overlay -->
      <div class="loading-overlay" v-if="isLoading">
        <div class="loading-spinner"></div>
      </div>
  
      <!-- Background and Header -->
      <div class="wave-bg"></div>
      <h1>Generate Payroll</h1>
  
      <!-- Alert Messages -->
      <div v-if="errorMessage" class="alert alert-error">
        {{ errorMessage }}
      </div>
      <div v-if="successMessage" class="alert alert-success">
        {{ successMessage }}
      </div>
  
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
<style scoped>
/* Main Container */
.payroll-container {
  width: 100%;
  min-height: 100vh;
  padding: 20px;
  background: #f2e6ff; /* Lightest purple */
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
  background: linear-gradient(135deg, #cc66ff, #660066); /* Medium to Deep purple */
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
}

h2 {
  color: #660066; /* Deep purple */
  margin-bottom: 20px;
  font-size: 1.8em;
}

h3 {
  color: #660066; /* Deep purple */
  margin-bottom: 15px;
  font-size: 1.3em;
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
  border: 1px solid #e6ccff; /* Light purple */
  transition: transform 0.3s ease;
}

.section:hover {
  transform: translateY(-2px);
}

/* Employee Selection Styles */
.employee-section {
  display: flex;
  gap: 25px;
  flex-wrap: wrap;
}

.employee-select {
  flex: 1;
  min-width: 300px;
}

.employee-select label {
  display: block;
  margin-bottom: 10px;
  color: #660066; /* Deep purple */
  font-weight: 500;
}

.employee-select select {
  width: 100%;
  padding: 12px;
  border: 2px solid #e6ccff; /* Light purple */
  border-radius: 8px;
  font-size: 1em;
  background-color: white;
  color: #660066; /* Deep purple */
  transition: all 0.3s ease;
}

.employee-select select:focus {
  border-color: #cc66ff; /* Medium purple */
  outline: none;
  box-shadow: 0 0 0 3px rgba(204, 102, 255, 0.2);
}

/* Employee Details Card */
.employee-details {
  flex: 2;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  padding: 20px;
  background: #f2e6ff; /* Lightest purple */
  border-radius: 8px;
  border: 1px solid #e6ccff; /* Light purple */
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.detail-item .label {
  color: #660066; /* Deep purple */
  font-size: 0.9em;
  font-weight: 500;
}

.detail-item .value {
  color: #cc66ff; /* Medium purple */
  font-size: 1.1em;
  font-weight: 600;
}

/* Table Styles */
.attendance-table {
  overflow-x: auto;
  margin-top: 20px;
  border-radius: 8px;
  border: 1px solid #e6ccff; /* Light purple */
}

table {
  width: 100%;
  border-collapse: collapse;
  background: white;
}

th {
  background: #f2e6ff; /* Lightest purple */
  color: #660066; /* Deep purple */
  padding: 15px;
  font-weight: 600;
  text-align: left;
  border-bottom: 2px solid #e6ccff; /* Light purple */
}

td {
  padding: 12px 15px;
  border-bottom: 1px solid #e6ccff; /* Light purple */
  color: #660066; /* Deep purple */
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
  color: #28a745;
}

.status-badge.absent {
  background: #ffebee;
  color: #dc3545;
}

.status-badge.late {
  background: #f2e6ff; /* Lightest purple */
  color: #cc66ff; /* Medium purple */
}

/* Form Controls */
input[type="number"],
input[type="text"] {
  padding: 10px 12px;
  border: 2px solid #e6ccff; /* Light purple */
  border-radius: 6px;
  font-size: 0.95em;
  color: #660066; /* Deep purple */
  transition: all 0.3s ease;
}

input[type="number"]:focus,
input[type="text"]:focus {
  border-color: #cc66ff; /* Medium purple */
  outline: none;
  box-shadow: 0 0 0 3px rgba(204, 102, 255, 0.2);
}

/* Checkbox Styling */
.checkbox-label {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  color: #660066; /* Deep purple */
}

input[type="checkbox"] {
  width: 18px;
  height: 18px;
  accent-color: #cc66ff; /* Medium purple */
  cursor: pointer;
}

/* Button Styles */
.generate-btn {
  background: linear-gradient(135deg, #cc66ff, #660066); /* Medium to Deep purple */
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

.generate-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 8px rgba(102, 0, 102, 0.3);
}

.generate-btn:active {
  transform: translateY(0);
}

/* Loading Spinner */
.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #e6ccff; /* Light purple */
  border-top-color: #cc66ff; /* Medium purple */
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* Summary Section */
.summary-section {
  background: white;
  padding: 30px;
  border-radius: 15px;
  border: 2px solid #e6ccff; /* Light purple */
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.summary-item {
  padding: 20px;
  background: #f2e6ff; /* Lightest purple */
  border-radius: 10px;
  text-align: center;
  transition: all 0.3s ease;
}

.summary-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(102, 0, 102, 0.1);
}

.summary-item .label {
  color: #660066; /* Deep purple */
  font-size: 0.9em;
  margin-bottom: 10px;
}

.summary-item .amount {
  font-size: 1.6em;
  font-weight: 600;
  color: #660066; /* Deep purple */
}

.summary-item .amount.positive {
  color: #28a745;
}

.summary-item .amount.negative {
  color: #dc3545;
}

.summary-item.total {
  background: linear-gradient(135deg, #cc66ff, #660066); /* Medium to Deep purple */
}

.summary-item.total .label,
.summary-item.total .amount {
  color: white;
}

/* Responsive Design */
@media (max-width: 768px) {
  .employee-section {
    flex-direction: column;
  }

  .employee-select,
  .employee-details {
    min-width: 100%;
  }

  .summary-grid {
    grid-template-columns: 1fr;
  }

  .generate-btn {
    width: 100%;
  }
}

/* Animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.section {
  animation: fadeIn 0.5s ease-out;
}
</style>