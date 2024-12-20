<template>
    <div class="salary-container">
      <div class="wave-bg"></div>
      
      <div class="content-wrapper">
        <!-- Header Section -->
        <div class="header-section">
          <h1>Salary Adjustment</h1>
        </div>
  
        <!-- Search Bar -->
        <div class="search-section">
          <div class="search-box">
            <input 
              type="text" 
              v-model="searchName"
              placeholder="Search employee..."
              class="purple-input"
            >
          </div>
        </div>
  
        <!-- Employees Table -->
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>Employee ID</th>
                <th>Name</th>
                <th>Department</th>
                <th>Position</th>
                <th>Rate/Hour</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="employee in filteredEmployees" :key="employee.id">
                <td>{{ employee.id }}</td>
                <td>{{ employee.name }}</td>
                <td>{{ employee.department }}</td>
                <td>{{ employee.position }}</td>
                <td>₱{{ formatCurrency(employee.ratePerHour) }}</td>
                <td>
                  <button 
                    class="adjust-btn"
                    @click="selectEmployee(employee)"
                  >
                    Adjust
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
  
        <!-- Adjustment Modal -->
        <div class="modal" v-if="selectedEmployee">
          <div class="modal-content">
            <div class="modal-header">
              <h2>Adjust Salary - {{ selectedEmployee.name }}</h2>
              <button class="close-btn" @click="closeModal">&times;</button>
            </div>
  
            <!-- Employee Details -->
            <div class="employee-details">
              <div class="info-grid">
                <div class="info-item">
                  <label>Employee ID</label>
                  <input type="text" :value="selectedEmployee.id" disabled class="purple-input">
                </div>
                <div class="info-item">
                  <label>Department</label>
                  <input type="text" :value="selectedEmployee.department" disabled class="purple-input">
                </div>
                <div class="info-item">
                  <label>Position</label>
                  <input type="text" :value="selectedEmployee.position" disabled class="purple-input">
                </div>
              </div>
  
              <!-- Rate Adjustment -->
              <div class="adjustment-section">
                <h3>Rate Adjustment</h3>
                <div class="rate-group">
                  <div class="current-rate">
                    <label>Current Rate (Per Hour)</label>
                    <input 
                      type="text" 
                      :value="'₱' + formatCurrency(selectedEmployee.ratePerHour)"
                      disabled 
                      class="purple-input"
                    >
                  </div>
                  <div class="new-rate">
                    <label>New Rate (Per Hour)</label>
                    <input 
                      type="number" 
                      v-model="newRate"
                      class="purple-input"
                      step="0.01"
                      min="0"
                    >
                  </div>
                </div>
              </div>
  
              <!-- Deductions Adjustment -->
              <div class="adjustment-section">
                <h3>Deductions Adjustment</h3>
                <div class="deductions-grid">
                  <div class="deduction-item">
                    <label>SSS Rate (%)</label>
                    <input 
                      type="number" 
                      v-model="deductions.sss" 
                      class="purple-input"
                      step="0.01"
                      min="0"
                      max="100"
                    >
                  </div>
                  <div class="deduction-item">
                    <label>PhilHealth Rate (%)</label>
                    <input 
                      type="number" 
                      v-model="deductions.philhealth" 
                      class="purple-input"
                      step="0.01"
                      min="0"
                      max="100"
                    >
                  </div>
                  <div class="deduction-item">
                    <label>Pag-IBIG</label>
                    <input 
                      type="number" 
                      v-model="deductions.pagibig" 
                      class="purple-input"
                      step="0.01"
                      min="0"
                    >
                  </div>
                  <div class="deduction-item">
                    <label>Tax Rate (%)</label>
                    <input 
                      type="number" 
                      v-model="deductions.tax" 
                      class="purple-input"
                      step="0.01"
                      min="0"
                      max="100"
                    >
                  </div>
                </div>
              </div>
  
              <!-- Save Button -->
              <div class="form-buttons">
                <button class="save-btn" @click="saveAdjustments">
                  Save Changes
                </button>
                <button class="cancel-btn" @click="closeModal">
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  <script>
  export default {
    name: 'SalaryAdjustment',
    data() {
      return {
        searchName: '',
        selectedEmployee: null,
        newRate: 0,
        deductions: {
          sss: 4.5,
          philhealth: 3,
          pagibig: 100,
          tax: 15
        },
        employees: [
          {
            id: 'EMP001',
            name: 'John Doe',
            department: 'IT',
            position: 'Senior Developer',
            ratePerHour: 312.50,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 15
            }
          },
          {
            id: 'EMP002',
            name: 'Jane Smith',
            department: 'HR',
            position: 'HR Manager',
            ratePerHour: 281.25,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 15
            }
          },
          {
            id: 'EMP003',
            name: 'Mike Johnson',
            department: 'Finance',
            position: 'Senior Accountant',
            ratePerHour: 250.00,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 15
            }
          },
          {
            id: 'EMP004',
            name: 'Sarah Wilson',
            department: 'Marketing',
            position: 'Marketing Specialist',
            ratePerHour: 218.75,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 12
            }
          },
          {
            id: 'EMP005',
            name: 'Robert Chen',
            department: 'IT',
            position: 'Junior Developer',
            ratePerHour: 156.25,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 10
            }
          },
          {
            id: 'EMP006',
            name: 'Maria Garcia',
            department: 'Operations',
            position: 'Operations Manager',
            ratePerHour: 293.75,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 15
            }
          },
          {
            id: 'EMP007',
            name: 'David Kim',
            department: 'IT',
            position: 'System Administrator',
            ratePerHour: 237.50,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 12
            }
          },
          {
            id: 'EMP008',
            name: 'Lisa Wong',
            department: 'Finance',
            position: 'Financial Analyst',
            ratePerHour: 225.00,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 12
            }
          },
          {
            id: 'EMP009',
            name: 'James Martinez',
            department: 'Marketing',
            position: 'Digital Marketing Lead',
            ratePerHour: 268.75,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 15
            }
          },
          {
            id: 'EMP010',
            name: 'Emily Santos',
            department: 'HR',
            position: 'HR Specialist',
            ratePerHour: 187.50,
            deductions: {
              sss: 4.5,
              philhealth: 3,
              pagibig: 100,
              tax: 10
            }
          }
        ]
      }
    },
  
    computed: {
      filteredEmployees() {
        const searchTerm = this.searchName.toLowerCase()
        return this.employees.filter(emp => 
          emp.name.toLowerCase().includes(searchTerm) ||
          emp.id.toLowerCase().includes(searchTerm) ||
          emp.department.toLowerCase().includes(searchTerm) ||
          emp.position.toLowerCase().includes(searchTerm)
        )
      }
    },
  
    methods: {
      formatCurrency(value) {
        return Number(value).toLocaleString('en-PH', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        })
      },
  
      selectEmployee(employee) {
        this.selectedEmployee = employee
        this.newRate = employee.ratePerHour
        this.deductions = { ...employee.deductions }
      },
  
      closeModal() {
        this.selectedEmployee = null
        this.newRate = 0
        this.deductions = {
          sss: 4.5,
          philhealth: 3,
          pagibig: 100,
          tax: 15
        }
      },
  
      async saveAdjustments() {
        try {
          if (!this.newRate || this.newRate <= 0) {
            alert('Please enter a valid rate')
            return
          }
  
          const adjustmentData = {
            employeeId: this.selectedEmployee.id,
            newRate: this.newRate,
            deductions: this.deductions
          }
  
          // Here you would typically make an API call
          console.log('Saving adjustments:', adjustmentData)
          
          // Update the employee in the local array
          const employeeIndex = this.employees.findIndex(emp => emp.id === this.selectedEmployee.id)
          if (employeeIndex !== -1) {
            this.employees[employeeIndex] = {
              ...this.employees[employeeIndex],
              ratePerHour: this.newRate,
              deductions: { ...this.deductions }
            }
          }
  
          alert('Salary adjustments saved successfully!')
          this.closeModal()
        } catch (error) {
          console.error('Error saving adjustments:', error)
          alert('Failed to save adjustments. Please try again.')
        }
      }
    }
  }
  </script>