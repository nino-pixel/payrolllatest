<template>
    <div class="employee-container">
      <div class="wave-bg"></div>
      
      <div class="content-wrapper">
        <!-- Header Section -->
        <div class="header-section">
          <h1>Employee Management</h1>
          <button class="add-btn" @click="openAddModal">
            <span>+</span> Add Employee
          </button>
        </div>
  
        <!-- Search and Filter Section -->
        <div class="search-section">
          <div class="search-box">
            <input 
              type="text" 
              v-model="searchQuery" 
              placeholder="Search employees..."
            >
          </div>
          <div class="filter-box">
            <select v-model="departmentFilter">
            
  <option value="">All Departments</option>
  <option value="Human Resources">Human Resources</option>
  <option value="Information Technology">Information Technology</option>
  <option value="Finance">Finance</option>
  <option value="Marketing">Marketing</option>
  <option value="Operations">Operations</option>
  <option value="Sales">Sales</option>
  <option value="Research">Research</option>
            </select>
          </div>
        </div>
  
        <!-- Employee Table -->
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>Employee ID</th>
                <th>Name</th>
                <th>Department</th>
                <th>Position</th>
                <th>Email</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="employee in filteredEmployees" :key="employee.id">
                <td>{{ employee.id }}</td>
                <td>{{ employee.name }}</td>
                <td>{{ employee.department }}</td>
                <td>{{ employee.position }}</td>
                <td>{{ employee.email }}</td>
                <td>
                  <span :class="['status', employee.status.toLowerCase()]">
                    {{ employee.status }}
                  </span>
                </td>
                <td class="actions">
                  <button @click="viewEmployee(employee)" class="view-btn">
                    <i class="fas fa-eye"></i>
                  </button>
                  <button @click="editEmployee(employee)" class="edit-btn">
                    <i class="fas fa-edit"></i>
                  </button>
                  <button @click="deleteEmployee(employee)" class="delete-btn">
                    <i class="fas fa-trash"></i>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
  
      <!-- Add/Edit Modal -->
      <div class="modal" v-if="showModal">
        <div class="modal-content">
          <h2>{{ isEditing ? 'Edit Employee' : 'Add Employee' }}</h2>
          <form @submit.prevent="submitForm">
            <div class="form-group">
              <label>Name</label>
              <input type="text" v-model="formData.name" required>
            </div>
            <div class="form-group">
              <label>Department</label>
              <select v-model="formData.department" required>
                <option value="Human Resources">Human Resources</option>
  <option value="Information Technology">Information Technology</option>
  <option value="Finance">Finance</option>
  <option value="Marketing">Marketing</option>
  <option value="Operations">Operations</option>
  <option value="Sales">Sales</option>
  <option value="Research">Research</option>
              </select>
            </div>
            <div class="form-group">
              <label>Position</label>
              
<select v-model="formData.position" required>
  <option value="">Select Position</option>
  <!-- Human Resources -->
  <option value="HR Manager">HR Manager</option>
  <option value="HR Specialist">HR Specialist</option>
  <option value="Recruitment Coordinator">Recruitment Coordinator</option>
  
  <!-- IT -->
  <option value="IT Manager">IT Manager</option>
  <option value="Senior Developer">Senior Developer</option>
  <option value="Junior Developer">Junior Developer</option>
  <option value="System Administrator">System Administrator</option>
  
  <!-- Finance -->
  <option value="Finance Manager">Finance Manager</option>
  <option value="Accountant">Accountant</option>
  <option value="Financial Analyst">Financial Analyst</option>
  
  <!-- Marketing -->
  <option value="Marketing Manager">Marketing Manager</option>
  <option value="Marketing Specialist">Marketing Specialist</option>
  <option value="Content Creator">Content Creator</option>
  
  <!-- Operations -->
  <option value="Operations Manager">Operations Manager</option>
  <option value="Operations Coordinator">Operations Coordinator</option>
  
  <!-- Sales -->
  <option value="Sales Manager">Sales Manager</option>
  <option value="Sales Representative">Sales Representative</option>
  
  <!-- Research -->
  <option value="Research Manager">Research Manager</option>
  <option value="Research Analyst">Research Analyst</option>
</select>
            </div>
            <div class="form-group">
              <label>Email</label>
              <input type="email" v-model="formData.email" required>
            </div>
            <div class="form-group">
              <label>Status</label>
              <select v-model="formData.status" required>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
                <option value="On Leave">On Leave</option>
              </select>
            </div>
            <div class="form-buttons">
              <button type="submit" class="submit-btn">
                {{ isEditing ? 'Update' : 'Add' }}
              </button>
              <button type="button" @click="closeModal" class="cancel-btn">
                Cancel
              </button>
            </div>
          </form>
        </div>
      </div>
  
      <!-- View Modal -->
      <div class="modal" v-if="showViewModal">
        <div class="modal-content">
          <h2>Employee Details</h2>
          <div class="employee-details">
            <div class="detail-row">
              <span class="label">ID:</span>
              <span class="value">{{ selectedEmployee.id }}</span>
            </div>
            <div class="detail-row">
              <span class="label">Name:</span>
              <span class="value">{{ selectedEmployee.name }}</span>
            </div>
            <div class="detail-row">
              <span class="label">Department:</span>
              <span class="value">{{ selectedEmployee.department }}</span>
            </div>
            <div class="detail-row">
              <span class="label">Position:</span>
              <span class="value">{{ selectedEmployee.position }}</span>
            </div>
            <div class="detail-row">
              <span class="label">Email:</span>
              <span class="value">{{ selectedEmployee.email }}</span>
            </div>
            <div class="detail-row">
              <span class="label">Status:</span>
              <span class="value">{{ selectedEmployee.status }}</span>
            </div>
          </div>
          <button @click="closeViewModal" class="close-btn">Close</button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'EmployeeManagement',
    data() {
      return {
        searchQuery: '',
        departmentFilter: '',
        showModal: false,
        showViewModal: false,
        isEditing: false,
        selectedEmployee: null,
        formData: {
          name: '',
          department: '',
          position: '',
          email: '',
          status: 'Active', 
          salary: '',
        hire_date: '',
        contact_number: '',
        address: ''
        },
        employees: [
          {
            id: 'EMP001',
          name: 'John Doe',
          department: 'Information Technology',
          position: 'Senior Developer',
          email: 'john.doe@company.com',
          status: 'Active',
          salary: 75000,
          hire_date: '2023-01-15',
          contact_number: '+1234567890',
          address: '123 Tech Street, IT City'
          },
          {
          id: 'EMP002',
          name: 'Jane Smith',
          department: 'Human Resources',
          position: 'HR Manager',
          email: 'jane.smith@company.com',
          status: 'Active',
          salary: 65000,
          hire_date: '2023-02-01',
          contact_number: '+1234567891',
          address: '456 HR Avenue, Management District'
        }
          // Add more sample employees
        ]
      }
    },
    computed: {
      filteredEmployees() {
        return this.employees.filter(emp => {
          const matchesSearch = emp.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                              emp.email.toLowerCase().includes(this.searchQuery.toLowerCase())
          const matchesDepartment = !this.departmentFilter || emp.department === this.departmentFilter
          return matchesSearch && matchesDepartment
        })
      }
    },
    methods: {
      async fetchEmployees() {
      try {
        const response = await axios.get('/api/employees')
        this.employees = response.data
      } catch (error) {
        console.error('Error fetching employees:', error)
      }
    },
    async addEmployee() {
      try {
        const response = await axios.post('/api/employees', this.formData)
        this.employees.push(response.data)
        this.showModal = false
        this.resetForm()
      } catch (error) {
        console.error('Error adding employee:', error)
      }
    },
      openAddModal() {
        this.isEditing = false
        this.formData = {
          name: '',
          department: '',
          position: '',
          email: '',
          status: 'Active'
        }
        this.showModal = true
      },
      async updateEmployee() {
      try {
        const response = await axios.put(`/api/employees/${this.formData.id}`, this.formData)
        const index = this.employees.findIndex(emp => emp.id === this.formData.id)
        this.employees[index] = response.data
        this.showModal = false
      } catch (error) {
        console.error('Error updating employee:', error)
      }
    },
      viewEmployee(employee) {
        this.selectedEmployee = employee
        this.showViewModal = true
      },
      async deleteEmployee(employee) {
      if (confirm('Are you sure you want to delete this employee?')) {
        try {
          await axios.delete(`/api/employees/${employee.id}`)
          this.employees = this.employees.filter(emp => emp.id !== employee.id)
        } catch (error) {
          console.error('Error deleting employee:', error)
        }
      }
    },
    resetForm() {
      this.formData = {
        name: '',
        department: '',
        position: '',
        email: '',
        status: 'Active',
        salary: '',
        hire_date: '',
        contact_number: '',
        address: ''
      }
    },
      submitForm() {
        if (this.isEditing) {
          const index = this.employees.findIndex(emp => emp.id === this.formData.id)
          this.employees[index] = { ...this.formData }
        } else {
          const newId = 'EMP' + String(this.employees.length + 1).padStart(3, '0')
          this.employees.push({
            ...this.formData,
            id: newId
          })
        }
        this.closeModal()
      },
      closeModal() {
        this.showModal = false
        this.formData = {
          name: '',
          department: '',
          position: '',
          email: '',
          status: 'Active'
        }
      },
      closeViewModal() {
        this.showViewModal = false
        this.selectedEmployee = null
      }
    }
    
  }
  </script>
  
  <style scoped>
.employee-container {
  height: 100vh;
  overflow: hidden;
  background: #f5f7fa;
  position: relative;
}

.wave-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 120px;
  background: linear-gradient(135deg, #6b2c91, #4a1f64);
  border-radius: 0 0 50% 50%;
  z-index: 0;
}

.content-wrapper {
  position: relative;
  z-index: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  padding: 1rem;
}

.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
}

.header-section h1 {
  color: white;
  font-size: 1.8rem;
  margin: 0;
}

.add-btn {
  background: white;
  color: #6b2c91;
  border: none;
  padding: 0.5rem 1.5rem;
  border-radius: 5px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 500;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.add-btn:hover {
  background: #f8f9fa;
  transform: translateY(-1px);
}

.search-section {
  display: flex;
  gap: 1rem;
  padding: 1rem 2rem;
  background: white;
  margin: 0 1rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.search-box input,
.filter-box select {
    width: 100%;
  padding: 12px;
  border: 2px solid #e6ccff;
  border-radius: 8px;
  font-size: 1em;
  color: #660066;
  background-color: white;
  transition: all 0.3s ease;
}

.search-box input:focus,
.filter-box select:focus {
    border-color: #cc66ff;
  outline: none;
  box-shadow: 0 0 0 3px rgba(204, 102, 255, 0.2);
  background-color: #f2e6ff;
}
.search-box::placeholder {
  color: #a880c7;
}

.table-container {
  flex: 1;
  overflow-y: auto;
  padding: 1rem 2rem;
  margin: 1rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: white;
}

th, td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid #e1e4e8;
  color: #4a5568;
}

th {
  background: #f8fafc;
  font-weight: 600;
  color: #2d3748;
}

.status {
  padding: 0.25rem 0.75rem;
  border-radius: 15px;
  font-size: 0.875rem;
  font-weight: 500;
}

.status.active {
  background: #e6f4ea;
  color: #1e7e34;
}

.status.inactive {
  background: #feeced;
  color: #dc3545;
}

.status.on-leave {
  background: #fff3cd;
  color: #856404;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

.actions button {
  padding: 0.4rem 0.8rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.view-btn { 
  background: #6b2c91; 
  color: white;
}

.edit-btn { 
  background: #28a745; 
  color: white;
}

.delete-btn { 
  background: #dc3545; 
  color: white;
}

.actions button:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}
select{
    background-color: #f2e6ff;
    color: #9737e0;
    font-weight:1000;
}
.modal-content {
  background: white;
  padding: 2rem;
  border-radius: 10px;
  width: 500px;
  max-width: 90%;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.modal-content h2 {
  color: #a880c7;  margin-bottom: 1.5rem;
  font-size: 1.5rem;
}

.form-group {
  margin-bottom: 1.2rem;
}
input{
    border-color: #cc66ff;
  outline: none;
  color: #9737e0;
    font-weight:1000;
  box-shadow: 0 0 0 3px rgba(204, 102, 255, 0.2);
  background-color: #f2e6ff;
}
.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #4a5568;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 0.6rem;
  border: 1px solid #e1e4e8;
  border-radius: 5px;
  color: #a880c7;  transition: all 0.2s ease;
}

.form-group input:focus,
.form-group select:focus {
  outline: none;
  border-color: #6b2c91;
  box-shadow: 0 0 0 2px rgba(107, 44, 145, 0.1);
}

.form-buttons {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
}

.submit-btn,
.cancel-btn {
  padding: 0.6rem 1.2rem;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s ease;
}

.submit-btn {
  background: #6b2c91;
  color: white;
  flex: 2;
}

.cancel-btn {
  background: #dc3545;
  color: white;
  flex: 1;
}

.submit-btn:hover,
.cancel-btn:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

.employee-details {
  margin: 1.5rem 0;
}

.detail-row {
  display: flex;
  margin-bottom: 0.8rem;
  padding: 0.5rem;
  border-bottom: 1px solid #e1e4e8;
}

.detail-row .label {
  font-weight: 500;
  width: 120px;
  color: #4a5568;
}

.detail-row .value {
    color: #a880c7;
}

.close-btn {
  width: 100%;
  padding: 0.6rem;
  background: #6b2c91;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: 500;
  margin-top: 1rem;
  transition: all 0.2s ease;
}

.close-btn:hover {
  background: #5a2578;
}
</style>