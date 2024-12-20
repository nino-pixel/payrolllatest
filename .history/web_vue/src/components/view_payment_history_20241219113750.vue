<template>
    <div class="payment-container">
      <div class="wave-bg"></div>
      
      <div class="content-wrapper">
        <!-- Header Section -->
        <div class="header-section">
          <h1>Payment History</h1>
          <button class="generate-btn" @click="openPayslipModal">
            <span>+</span> Generate Payslip
          </button>
        </div>
  
        <!-- Search and Filter Section -->
        <div class="search-section">
          <div class="search-box">
            <input 
              type="text" 
              v-model="searchQuery" 
              placeholder="Search by name..."
              class="purple-input"
            >
          </div>
          <div class="filter-box">
            <select v-model="departmentFilter" class="purple-select">
              <option value="">All Departments</option>
              <option value="HR">HR</option>
              <option value="IT">IT</option>
              <option value="Finance">Finance</option>
              <option value="Marketing">Marketing</option>
            </select>
          </div>
          <div class="date-filter">
            <input 
              type="month" 
              v-model="dateFilter"
              class="purple-input"
            >
          </div>
        </div>
  
        <!-- Payment Table -->
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Department</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="payment in filteredPayments" :key="payment.id">
                <td>{{ payment.name }}</td>
                <td>{{ payment.department }}</td>
                <td>₱{{ formatCurrency(payment.amount) }}</td>
                <td>{{ formatDate(payment.date) }}</td>
                <td>
                  <span 
                    :class="['status', payment.status.toLowerCase()]"
                    @click="showDetails(payment)"
                    :style="{ cursor: isClickableStatus(payment.status) ? 'pointer' : 'default' }"
                  >
                    {{ payment.status }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
  
      <!-- Payment Details Modal -->
      <div class="modal" v-if="showDetailsModal">
        <div class="modal-content">
          <h2>Payment Details</h2>
          <div class="payment-details">
            <div class="detail-row">
              <span class="label">Employee:</span>
              <span class="value">{{ selectedPayment.name }}</span>
            </div>
            <div class="detail-row">
              <span class="label">Amount:</span>
              <span class="value">₱{{ formatCurrency(selectedPayment.amount) }}</span>
            </div>
            <div class="detail-row">
              <span class="label">Date:</span>
              <span class="value">{{ formatDate(selectedPayment.date) }}</span>
            </div>
            <div class="detail-row">
              <span class="label">Status:</span>
              <span :class="['status', selectedPayment.status.toLowerCase()]">
                {{ selectedPayment.status }}
              </span>
            </div>
            <div class="summary-section">
              <h3>Summary</h3>
              <p>{{ selectedPayment.summary }}</p>
            </div>
            <div class="form-buttons">
              <button 
                class="submit-btn" 
                @click="resendPayment"
                v-if="isClickableStatus(selectedPayment.status)"
              >
                Resend Payment
              </button>
              <button class="cancel-btn" @click="closeDetailsModal">Cancel</button>
            </div>
          </div>
        </div>
      </div>
  
      <!-- Payslip Generation Modal -->
      <div class="modal" v-if="showPayslipModal">
        <div class="modal-content payslip-modal">
          <div class="modal-header">
            <h2>Generate Payslip</h2>
            <button class="close-btn" @click="closePayslipModal">&times;</button>
          </div>
  
          <!-- Employee Search -->
          <div class="form-group">
            <label>Employee Name</label>
            <input 
              type="text" 
              v-model="payslipName"
              @input="searchEmployee"
              placeholder="Enter employee name"
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
  
          <!-- Payslip Preview -->
          <div class="payslip-preview" v-if="selectedPayslipEmployee" ref="payslipContent">
            <div class="payslip-header">
              <div class="company-info">
                <h2>Company Name</h2>
                <p>123 Company Road, Manila, Philippines</p>
                <p>Phone: +63 123 456 7890, Email: hr@company.com</p>
              </div>
              <div class="payslip-title">
                <h1>PAYSLIP</h1>
              </div>
            </div>
  
            <div class="payslip-grid">
              <!-- Employee Info -->
              <div class="info-section">
                <h3>Employee Information</h3>
                <div class="info-row">
                  <span class="label">Name:</span>
                  <span class="value">{{ selectedPayslipEmployee.name }}</span>
                </div>
                <div class="info-row">
                  <span class="label">ID:</span>
                  <span class="value">{{ selectedPayslipEmployee.id }}</span>
                </div>
                <div class="info-row">
                  <span class="label">Department:</span>
                  <span class="value">{{ selectedPayslipEmployee.department }}</span>
                </div>
              </div>
  
              <!-- Payment Info -->
              <div class="info-section">
                <h3>Payment Information</h3>
                <div class="info-row">
                  <span class="label">Pay Period:</span>
                  <span class="value">{{ getCurrentPayPeriod() }}</span>
                </div>
                <div class="info-row">
                  <span class="label">Pay Date:</span>
                  <span class="value">{{ formatDate(new Date()) }}</span>
                </div>
              </div>
            </div>
  
            <!-- Earnings Section -->
            <div class="payslip-section">
              <h3>Earnings</h3>
              <table class="payslip-table">
                <thead>
                  <tr>
                    <th>Description</th>
                    <th>Amount</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Basic Salary</td>
                    <td>₱{{ formatCurrency(selectedPayslipEmployee.amount) }}</td>
                  </tr>
                  <!-- Add more earnings rows as needed -->
                </tbody>
                <tfoot>
                  <tr>
                    <td><strong>Gross Pay</strong></td>
                    <td><strong>₱{{ formatCurrency(selectedPayslipEmployee.amount) }}</strong></td>
                  </tr>
                </tfoot>
              </table>
            </div>
  
            <!-- Deductions Section -->
            <div class="payslip-section">
              <h3>Deductions</h3>
              <table class="payslip-table">
                <thead>
                  <tr>
                    <th>Description</th>
                    <th>Amount</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>SSS</td>
                    <td>₱{{ formatCurrency(calculateSSS()) }}</td>
                  </tr>
                  <tr>
                    <td>PhilHealth</td>
                    <td>₱{{ formatCurrency(calculatePhilHealth()) }}</td>
                  </tr>
                  <tr>
                    <td>Pag-IBIG</td>
                    <td>₱{{ formatCurrency(calculatePagIbig()) }}</td>
                  </tr>
                  <tr>
                    <td>Withholding Tax</td>
                    <td>₱{{ formatCurrency(calculateTax()) }}</td>
                  </tr>
                </tbody>
                <tfoot>
                  <tr>
                    <td><strong>Total Deductions</strong></td>
                    <td><strong>₱{{ formatCurrency(totalDeductions) }}</strong></td>
                  </tr>
                </tfoot>
              </table>
            </div>
  
            <!-- Net Pay Section -->
            <div class="payslip-section net-pay">
              <table class="payslip-table">
                <tr>
                  <td><strong>NET PAY</strong></td>
                  <td><strong>₱{{ formatCurrency(netPay) }}</strong></td>
                </tr>
              </table>
            </div>
          </div>
  
          <!-- Action Buttons -->
          <div class="form-buttons">
            <button 
              class="print-btn" 
              @click="printPayslipToPDF"
              :disabled="!selectedPayslipEmployee"
            >
              <i class="fas fa-print"></i> Print PDF
            </button>
            <button class="cancel-btn" @click="closePayslipModal">Cancel</button>
          </div>
        </div>
      </div>
    </div>
  </template>