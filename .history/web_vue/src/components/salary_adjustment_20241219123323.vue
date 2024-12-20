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
 <!-- Adjustment Form Modal -->
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
                    :value="'₱' + formatCurrency(currentRate)"
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
        <div class="adjustment-form">
          <!-- Employee Search -->
          <div class="form-group">
            <label>Employee Name</label>
            <input 
              type="text" 
              v-model="searchName"
              @input="searchEmployee"
              placeholder="Search employee..."
              class="purple-input"
            >
            <!-- Employee Suggestions -->
            <div class="suggestions" v-if="showSuggestions">
              <div 
                v-for="emp in employeeSuggestions" 
                :key="emp.id"
                class="suggestion-item"
                @click="selectEmployee(emp)"
              >
                {{ emp.name }} - {{ emp.department }}
              </div>
            </div>
          </div>
  
          <!-- Employee Details -->
          <div class="employee-details" v-if="selectedEmployee">
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
                    :value="'₱' + formatCurrency(currentRate)"
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
        showSuggestions: false,
        selectedEmployee: null,
        currentRate: 0,
        newRate: 0,
        employeeSuggestions: [],
        deductions: {
          sss: 4.5,
          philhealth: 3,
          pagibig: 100,
          tax: 15
        },
        // Sample employee data (replace with API call)
        employees: [
  {
    id: 'EMP001',
    name: 'John Doe',
    department: 'IT',
    position: 'Senior Developer',
    ratePerHour: 312.50, // 50,000 / 160 hours
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
    ratePerHour: 281.25, // 45,000 / 160 hours
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
    ratePerHour: 250.00, // 40,000 / 160 hours
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
    ratePerHour: 218.75, // 35,000 / 160 hours
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
    ratePerHour: 156.25, // 25,000 / 160 hours
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
    ratePerHour: 293.75, // 47,000 / 160 hours
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
    ratePerHour: 237.50, // 38,000 / 160 hours
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
    ratePerHour: 225.00, // 36,000 / 160 hours
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
    ratePerHour: 268.75, // 43,000 / 160 hours
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
    ratePerHour: 187.50, // 30,000 / 160 hours
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
    return this.employees.filter(emp => 
      emp.name.toLowerCase().includes(this.searchName.toLowerCase()) ||
      emp.id.toLowerCase().includes(this.searchName.toLowerCase()) ||
      emp.department.toLowerCase().includes(this.searchName.toLowerCase()) ||
      emp.position.toLowerCase().includes(this.searchName.toLowerCase())
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
      searchEmployee() {
        if (this.searchName.length < 2) {
          this.showSuggestions = false
          return
        }
        
        this.employeeSuggestions = this.employees.filter(emp => 
          emp.name.toLowerCase().includes(this.searchName.toLowerCase())
        )
        this.showSuggestions = this.employeeSuggestions.length > 0
      },
      selectEmployee(employee) {
        this.selectedEmployee = employee
        this.searchName = employee.name
        this.showSuggestions = false
        this.currentRate = employee.ratePerHour
        this.newRate = employee.ratePerHour
        this.deductions = { ...employee.deductions }
      },
      async saveAdjustments() {
        try {
          // Validate inputs
          if (!this.newRate || this.newRate <= 0) {
            alert('Please enter a valid rate')
            return
          }
  
          // Prepare data for API
          const adjustmentData = {
            employeeId: this.selectedEmployee.id,
            newRate: this.newRate,
            deductions: this.deductions
          }
  
          // API call would go here
          console.log('Saving adjustments:', adjustmentData)
          
          // Show success message
          alert('Salary adjustments saved successfully!')
          
          // Update local data
          this.currentRate = this.newRate
        } catch (error) {
          console.error('Error saving adjustments:', error)
          alert('Failed to save adjustments. Please try again.')
        }
      }
      closeModal() {
    this.selectedEmployee = null
    this.newRate = 0
    this.deductions = {
      sss: 4.5,
      philhealth: 3,
      pagibig: 100,
      tax: 15
    }
  }
    }
  }
  </script>
  
  <style scoped>
  .salary-container {
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
    z-index: 0;
  }
  
  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 2rem;
  }
  
  .header-section {
    margin-bottom: 2rem;
  }
  
  .header-section h1 {
    color: white;
    font-size: 1.8rem;
  }
  
  .adjustment-form {
    background: white;
    padding: 2rem;
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    max-width: 800px;
    margin: 0 auto;
  }
  
  .form-group {
    margin-bottom: 1.5rem;
    position: relative;
  }
  
  .form-group label {
    display: block;
    margin-bottom: 0.5rem;
    color: #660066;
    font-weight: 500;
  }
  
  .purple-input {
    width: 100%;
    padding: 0.8rem;
    border: 2px solid #e6ccff;
    border-radius: 8px;
    font-size: 1em;
    color: #660066;
    background-color: white;
    transition: all 0.3s ease;
  }
  
  .purple-input:focus {
    border-color: #cc66ff;
    outline: none;
    box-shadow: 0 0 0 3px rgba(204, 102, 255, 0.2);
  }
  
  .purple-input:disabled {
    background-color: #f8f9fa;
    cursor: not-allowed;
  }
  
  .suggestions {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: white;
    border: 1px solid #e6ccff;
    border-radius: 5px;
    max-height: 200px;
    overflow-y: auto;
    z-index: 1000;
  }
  
  .suggestion-item {
    padding: 0.8rem;
    cursor: pointer;
    transition: background-color 0.2s ease;
  }
  
  .suggestion-item:hover {
    background-color: #f2e6ff;
  }
  
  .info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 2rem;
  }
  
  .adjustment-section {
    margin-bottom: 2rem;
  }
  
  .adjustment-section h3 {
    color: #660066;
    margin-bottom: 1rem;
  }
  
  .rate-group {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
  }
  
  .deductions-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
  }
  
  .form-buttons {
    margin-top: 2rem;
    display: flex;
    justify-content: flex-end;
  }
  
  .save-btn {
    background: linear-gradient(135deg, #cc66ff, #660066);
    color: white;
    border: none;
    padding: 0.8rem 2rem;
    border-radius: 5px;
    cursor: pointer;
    font-weight: 500;
    transition: all 0.3s ease;
  }
  
  .save-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(102, 0, 102, 0.2);
  }
  
  @media (max-width: 768px) {
    .content-wrapper {
      padding: 1rem;
    }
    
    .adjustment-form {
      padding: 1rem;
    }
    
    .info-grid,
    .rate-group,
    .deductions-grid {
      grid-template-columns: 1fr;
    }
  }
  </style>