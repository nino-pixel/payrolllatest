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