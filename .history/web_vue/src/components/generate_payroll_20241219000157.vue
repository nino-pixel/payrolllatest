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
  
      <!-- Continue with Deductions and Summary sections? -->
    </div>
    
  </template>