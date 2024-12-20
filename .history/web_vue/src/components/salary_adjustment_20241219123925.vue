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