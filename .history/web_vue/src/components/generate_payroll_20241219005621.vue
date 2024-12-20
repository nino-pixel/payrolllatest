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
      <div class="section increases-section" v-if="selectedEmployee">
    <h2>Salary Increases and Bonuses</h2>
    
    <!-- Performance-Based Increases -->
    <div class="increases-grid">
      <div class="increase-category">
        <h3>Performance-Based Increases</h3>
        <div class="increase-items">
          <div class="increase-item" v-for="item in performanceIncreases" :key="item.id">
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
                = ${{ calculateIncrease(item) }}
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Incentives and Bonuses -->
      <div class="increase-category">
        <h3>Incentives and Bonuses</h3>
        <div class="increase-items">
          <div class="increase-item" v-for="item in incentivesAndBonuses" :key="item.id">
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
                = ${{ calculateIncrease(item) }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
</div>

    <!-- Deductions Section -->
    <div class="section deductions-section">
      <h2>Deductions</h2>
      <div class="deductions-grid">
        <!-- Statutory Deductions -->
        <div class="deduction-category">
          <h3>Statutory Deductions</h3>
          <div class="deduction-items">
            <div class="deduction-item" v-for="item in statutoryDeductions" :key="item.id">
              <div class="deduction-info">
                <span class="deduction-name">{{ item.name }}</span>
                <div class="tooltip" :data-tooltip="item.description">ⓘ</div>
              </div>
              <div class="deduction-amount">
                <span class="rate">{{ item.rate }}%</span>
                = ${{ calculateDeduction(item) }}
              </div>
            </div>
          </div>
        </div>

        <!-- Other Deductions -->
        <div class="deduction-category">
          <h3>Other Deductions</h3>
          <div class="deduction-items">
            <div class="deduction-item" v-for="item in otherDeductions" :key="item.id">
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
                <div class="calculated-amount">
                  = ${{ calculateDeduction(item) }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Summary Section -->
    <div class="section summary-section">
      <h2>Payroll Summary</h2>
      <div class="summary-grid">
        <div class="summary-item">
          <span class="label">Base Salary</span>
          <span class="amount">${{ employeeDetails?.baseSalary || 0 }}</span>
        </div>
        <div class="summary-item">
          <span class="label">Total Increases</span>
          <span class="amount positive">+${{ totalIncreases }}</span>
        </div>
        <div class="summary-item">
          <span class="label">Total Deductions</span>
          <span class="amount negative">-${{ totalDeductions }}</span>
        </div>
        <div class="summary-item total">
          <span class="label">Net Salary</span>
          <span class="amount">${{ netSalary }}</span>
        </div>
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
      { id: 'EMP003', name: 'Mike Johnson', department: 'Finance', position: 'Financial Analyst', baseSalary: 4200 },
      { id: 'EMP004', name: 'Sarah Williams', department: 'Marketing', position: 'Marketing Director', baseSalary: 5500 },
      { id: 'EMP005', name: 'David Brown', department: 'Operations', position: 'Operations Manager', baseSalary: 4800 },
      { id: 'EMP006', name: 'Emily Davis', department: 'IT', position: 'Software Engineer', baseSalary: 4000 },
      { id: 'EMP007', name: 'Michael Wilson', department: 'Sales', position: 'Sales Manager', baseSalary: 4600 },
      { id: 'EMP008', name: 'Lisa Anderson', department: 'HR', position: 'HR Specialist', baseSalary: 3800 },
      { id: 'EMP009', name: 'Robert Taylor', department: 'Finance', position: 'Accountant', baseSalary: 3900 },
      { id: 'EMP010', name: 'Jennifer Martin', department: 'Marketing', position: 'Marketing Specialist', baseSalary: 3700 }
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
        // ... existing data ...
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
      // Add more incentives...
    ],
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
      // Add more statutory deductions...
    ],
    otherDeductions: [
      {
        id: 3,
        name: 'Health Insurance',
        description: 'Optional health insurance premium',
        type: 'fixed',
        amount: 0,
        selected: false
      },
      // Add more deductions...
    ]
  };
      },

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
      },
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

  loadEmployeeData() {
    if (this.selectedEmployee) {
      // Find employee details
      this.employeeDetails = this.employees.find(emp => emp.id === this.selectedEmployee);
      
      // Load generated attendance records
      this.attendanceRecords = this.generateSampleRecords();
      
      // Calculate default deductions
      this.calculateDefaultDeductions();
    }
  },
    }
  }
  </script>
  <style scoped>
  .payroll-container {
    width: 100%;
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
  
  .section {
    background: white;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    position: relative;
    z-index: 1;
  }
  
  /* Employee Selection Styles */
  .employee-section {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
  }
  
  .employee-select {
    flex: 1;
    min-width: 300px;
  }
  
  .employee-select label {
    display: block;
    margin-bottom: 8px;
    color: #4a1f64;
    font-weight: 500;
  }
  
  .employee-select select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 1em;
  }
  
  .employee-details {
    flex: 2;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
    padding: 15px;
    background: #f8f9fa;
    border-radius: 8px;
  }
  
  .detail-item {
    display: flex;
    flex-direction: column;
    gap: 5px;
  }
  
  .detail-item .label {
    color: #666;
    font-size: 0.9em;
  }
  
  .detail-item .value {
    font-weight: 500;
    color: #4a1f64;
  }
  
  /* Attendance Table Styles */
  .attendance-table {
    overflow-x: auto;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
  }
  
  th, td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #ddd;
  }
  
  th {
    background-color: #f8f9fa;
    color: #4a1f64;
    font-weight: 500;
  }
  
  td.present { color: #28a745; }
  td.absent { color: #dc3545; }
  td.late { color: #ffc107; }
  
  /* Increases and Deductions Grid */
  .increases-grid,
  .deductions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
    margin-top: 15px;
  }
  
  .increase-category,
  .deduction-category {
    background: #f8f9fa;
    padding: 15px;
    border-radius: 8px;
  }
  
  h3 {
    color: #4a1f64;
    margin-bottom: 15px;
    font-size: 1.1em;
  }
  
  .increase-items,
  .deduction-items {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }
  
  .increase-item,
  .deduction-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px;
    background: white;
    border-radius: 5px;
    border: 1px solid #ddd;
  }
  
  .increase-item label {
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  .increase-item input[type="number"] {
    width: 100px;
    padding: 5px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  
  .increase-item input[type="checkbox"] {
    margin: 0;
  }
  
  /* Generate Button Styles */
  .generate-section {
    display: flex;
    justify-content: center;
    margin-top: 30px;
  }
  
  .generate-btn {
    background: #6b2c91;
    color: white;
    border: none;
    padding: 12px 30px;
    border-radius: 5px;
    font-size: 1.1em;
    cursor: pointer;
    transition: all 0.3s ease;
  }
  
  .generate-btn:hover {
    background: #4a1f64;
    transform: translateY(-2px);
  }
  
  .generate-btn:active {
    transform: translateY(0);
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
  
    .increases-grid,
    .deductions-grid {
      grid-template-columns: 1fr;
    }
  
    .increase-item,
    .deduction-item {
      flex-direction: column;
      align-items: flex-start;
      gap: 8px;
    }
  
    .increase-item input[type="number"] {
      width: 100%;
    }
  }
  
  /* Additional Utility Classes */
  .text-right { text-align: right; }
  .text-center { text-align: center; }
  .text-bold { font-weight: 500; }
  .mt-2 { margin-top: 20px; }
  .mb-2 { margin-bottom: 20px; }
  
  /* Animation for loading states */
  .loading {
    opacity: 0.7;
    pointer-events: none;
  }
  
  /* Tooltip styles */
  [data-tooltip] {
    position: relative;
    cursor: help;
  }
  
  [data-tooltip]:hover::before {
    content: attr(data-tooltip);
    position: absolute;
    bottom: 100%;
    left: 50%;
    transform: translateX(-50%);
    padding: 5px 10px;
    background: rgba(0, 0, 0, 0.8);
    color: white;
    border-radius: 4px;
    font-size: 0.8em;
    white-space: nowrap;
    z-index: 10;
  }
  </style>