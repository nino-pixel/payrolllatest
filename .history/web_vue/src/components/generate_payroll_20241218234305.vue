<template>
    <div class="payroll-container">
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
            <span class="label">Employee ID:</span>
            <span class="value">{{ employeeDetails.id }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Department:</span>
            <span class="value">{{ employeeDetails.department }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Position:</span>
            <span class="value">{{ employeeDetails.position }}</span>
          </div>
          <div class="detail-item">
            <span class="label">Base Salary:</span>
            <span class="value">${{ employeeDetails.baseSalary }}/month</span>
          </div>
        </div>
      </div>
  
      <!-- Attendance Records Section -->
      <div class="section attendance-section" v-if="selectedEmployee">
        <h2>Attendance Records</h2>
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
              <tr v-for="record in attendanceRecords" :key="record.date">
                <td>{{ record.date }}</td>
                <td>{{ record.timeIn }}</td>
                <td>{{ record.timeOut }}</td>
                <td :class="record.status.toLowerCase()">{{ record.status }}</td>
                <td>{{ record.hoursWorked }}</td>
              </tr>
            </tbody>
          </table>
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
              <div class="increase-item" v-for="increase in performanceIncreases" :key="increase.id">
                <label>
                  <input type="checkbox" v-model="increase.selected">
                  {{ increase.name }}
                </label>
                <input type="number" v-model="increase.amount" :disabled="!increase.selected">
              </div>
            </div>
          </div>
  
          <!-- Continue with other increase categories... -->
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
              <div class="deduction-item" v-for="deduction in statutoryDeductions" :key="deduction.id">
                <span class="deduction-name">{{ deduction.name }}</span>
                <span class="deduction-amount">${{ deduction.amount }}</span>
              </div>
            </div>
          </div>
  
          <!-- Continue with other deduction categories... -->
        </div>
      </div>
  
      <!-- Generate Button -->
      <div class="generate-section">
        <button class="generate-btn" @click="generatePayroll">
          Generate Payroll
        </button>
      </div>
    </div>
  </template>
  <script>
  export default {
    name: 'GeneratePayroll',
    data() {
      return {
        selectedEmployee: '',
        employees: [
          { id: 'EMP001', name: 'John Doe', department: 'IT', position: 'Senior Developer', baseSalary: 5000 },
          { id: 'EMP002', name: 'Jane Smith', department: 'HR', position: 'HR Manager', baseSalary: 4500 },
          // Add more employees as needed
        ],
        employeeDetails: null,
        attendanceRecords: [],
        
        // Performance-Based Increases
        performanceIncreases: [
          { id: 1, name: 'Merit Raise', selected: false, amount: 0, type: 'percentage' },
          { id: 2, name: 'Promotion Raise', selected: false, amount: 0, type: 'fixed' },
          { id: 3, name: 'Annual Increment', selected: false, amount: 0, type: 'percentage' }
        ],
  
        // Incentives and Bonuses
        incentivesAndBonuses: [
          { id: 4, name: 'Commission', selected: false, amount: 0, type: 'percentage' },
          { id: 5, name: 'Performance Bonus', selected: false, amount: 0, type: 'fixed' },
          { id: 6, name: 'Attendance Bonus', selected: false, amount: 0, type: 'fixed' },
          { id: 7, name: 'Holiday Bonus', selected: false, amount: 0, type: 'fixed' },
          { id: 8, name: 'Referral Bonus', selected: false, amount: 0, type: 'fixed' }
        ],
  
        // Statutory Increases
        statutoryIncreases: [
          { id: 9, name: 'Cost of Living Adjustment', selected: false, amount: 0, type: 'percentage' },
          { id: 10, name: 'Minimum Wage Adjustment', selected: false, amount: 0, type: 'fixed' }
        ],
  
        // Role-Specific Increases
        roleSpecificIncreases: [
          { id: 11, name: 'Shift Differential', selected: false, amount: 0, type: 'percentage' },
          { id: 12, name: 'Hazard Pay', selected: false, amount: 0, type: 'percentage' },
          { id: 13, name: 'Special Project Bonus', selected: false, amount: 0, type: 'fixed' }
        ],
  
        // Statutory Deductions
        statutoryDeductions: [
          { id: 1, name: 'Income Tax', amount: 0, type: 'percentage', rate: 20 },
          { id: 2, name: 'Social Security', amount: 0, type: 'percentage', rate: 6.2 },
          { id: 3, name: 'Medicare', amount: 0, type: 'percentage', rate: 1.45 }
        ],
  
        // Company Deductions
        companyDeductions: [
          { id: 4, name: 'Loan Repayment', amount: 0, type: 'fixed' },
          { id: 5, name: 'Equipment Cost', amount: 0, type: 'fixed' },
          { id: 6, name: 'Uniform Cost', amount: 0, type: 'fixed' }
        ],
  
        // Voluntary Deductions
        voluntaryDeductions: [
          { id: 7, name: 'Additional Retirement', amount: 0, type: 'percentage' },
          { id: 8, name: 'Health Insurance', amount: 0, type: 'fixed' },
          { id: 9, name: 'Life Insurance', amount: 0, type: 'fixed' }
        ]
      }
    },
  
    methods: {
      loadEmployeeData() {
        if (this.selectedEmployee) {
          // Simulate API call to get employee details
          this.employeeDetails = this.employees.find(emp => emp.id === this.selectedEmployee)
          
          // Load attendance records
          this.loadAttendanceRecords()
          
          // Calculate default deductions
          this.calculateDefaultDeductions()
        }
      },
  
      loadAttendanceRecords() {
        // Simulate API call to get attendance records
        this.attendanceRecords = [
          {
            date: '2024-01-15',
            timeIn: '08:00 AM',
            timeOut: '05:00 PM',
            status: 'Present',
            hoursWorked: 8
          },
          // Add more attendance records
        ]
      },
  
      calculateDefaultDeductions() {
        if (this.employeeDetails) {
          // Calculate statutory deductions
          this.statutoryDeductions.forEach(deduction => {
            if (deduction.type === 'percentage') {
              deduction.amount = (this.employeeDetails.baseSalary * deduction.rate) / 100
            }
          })
        }
      },
  
      calculateTotalIncreases() {
        let total = 0
        const categories = [
          this.performanceIncreases,
          this.incentivesAndBonuses,
          this.statutoryIncreases,
          this.roleSpecificIncreases
        ]
  
        categories.forEach(category => {
          category.forEach(increase => {
            if (increase.selected) {
              if (increase.type === 'percentage') {
                total += (this.employeeDetails.baseSalary * increase.amount) / 100
              } else {
                total += Number(increase.amount)
              }
            }
          })
        })
  
        return total
      },
  
      calculateTotalDeductions() {
        let total = 0
        const categories = [
          this.statutoryDeductions,
          this.companyDeductions,
          this.voluntaryDeductions
        ]
  
        categories.forEach(category => {
          category.forEach(deduction => {
            if (deduction.type === 'percentage') {
              total += (this.employeeDetails.baseSalary * deduction.amount) / 100
            } else {
              total += Number(deduction.amount)
            }
          })
        })
  
        return total
      },
  
      generatePayroll() {
        if (!this.selectedEmployee) return
  
        const totalIncreases = this.calculateTotalIncreases()
        const totalDeductions = this.calculateTotalDeductions()
        const netSalary = this.employeeDetails.baseSalary + totalIncreases - totalDeductions
  
        // Here you would typically send this data to your backend
        console.log({
          employeeId: this.selectedEmployee,
          baseSalary: this.employeeDetails.baseSalary,
          totalIncreases,
          totalDeductions,
          netSalary,
          payrollDate: new Date().toISOString()
        })
      }
    }
  }
  </script>