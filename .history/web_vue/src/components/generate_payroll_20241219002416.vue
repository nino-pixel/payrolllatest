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