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
    <tbody>
      <tr>
        <td><strong>NET PAY</strong></td>
        <td><strong>₱{{ formatCurrency(netPay) }}</strong></td>
      </tr>
    </tbody>
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
  <script>
  import html2pdf from 'html2pdf.js'
  
  export default {
    name: 'ViewPaymentHistory',
    data() {
      return {
        // Search and Filter
        searchQuery: '',
        departmentFilter: '',
        dateFilter: '',
        
        // Modals
        showDetailsModal: false,
        showPayslipModal: false,
        
        // Selected Items
        selectedPayment: null,
        selectedPayslipEmployee: null,
        
        // Payslip Generation
        payslipName: '',
        showSuggestions: false,
        employeeSuggestions: [],
        
        // Sample Data (Replace with API calls)
        payments: [
          {
            id: 1,
            name: 'John Doe',
            department: 'IT',
            position: 'Developer',
            amount: 25000,
            date: '2024-02-15',
            status: 'Sent',
            summary: ''
          },
          {
            id: 2,
            name: 'Jane Smith',
            department: 'HR',
            position: 'HR Manager',
            amount: 30000,
            date: '2024-02-15',
            status: 'Failed',
            summary: 'Transaction failed due to invalid bank account details.'
          },
          {
            id: 3,
            name: 'Mike Johnson',
            department: 'Finance',
            position: 'Accountant',
            amount: 35000,
            date: '2024-02-15',
            status: 'Returned',
            summary: 'Payment returned due to account restrictions.'
          }
        ]
      }
    },
  
    computed: {
      filteredPayments() {
        return this.payments.filter(payment => {
          const matchesName = payment.name.toLowerCase()
            .includes(this.searchQuery.toLowerCase())
          const matchesDepartment = !this.departmentFilter || 
            payment.department === this.departmentFilter
          const matchesDate = !this.dateFilter || 
            payment.date.startsWith(this.dateFilter)
          
          return matchesName && matchesDepartment && matchesDate
        })
      },
  
      totalDeductions() {
        if (!this.selectedPayslipEmployee) return 0
        return this.calculateSSS() + 
               this.calculatePhilHealth() + 
               this.calculatePagIbig() + 
               this.calculateTax()
      },
  
      netPay() {
        if (!this.selectedPayslipEmployee) return 0
        return this.selectedPayslipEmployee.amount - this.totalDeductions
      }
    },
  
    methods: {
      // Formatting Methods
      formatCurrency(value) {
        return value.toLocaleString('en-PH')
      },
  
      formatDate(date) {
        return new Date(date).toLocaleDateString('en-PH', {
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        })
      },
  
      getCurrentPayPeriod() {
        const date = new Date()
        return `${date.toLocaleString('default', { month: 'long' })} ${date.getFullYear()}`
      },
  
      // Status Methods
      isClickableStatus(status) {
        return ['Failed', 'Returned'].includes(status)
      },
  
      // Modal Methods
      showDetails(payment) {
        if (this.isClickableStatus(payment.status)) {
          this.selectedPayment = payment
          this.showDetailsModal = true
        }
      },
  
      closeDetailsModal() {
        this.showDetailsModal = false
        this.selectedPayment = null
      },
  
      // Payslip Methods
      openPayslipModal() {
        this.showPayslipModal = true
        this.payslipName = ''
        this.selectedPayslipEmployee = null
        this.showSuggestions = false
      },
  
      closePayslipModal() {
        this.showPayslipModal = false
        this.payslipName = ''
        this.selectedPayslipEmployee = null
      },
  
      searchEmployee() {
        if (this.payslipName.length < 2) {
          this.showSuggestions = false
          return
        }
        
        this.employeeSuggestions = this.payments
          .filter(emp => emp.name.toLowerCase().includes(this.payslipName.toLowerCase()))
          .filter(emp => emp.status === 'Sent')
        
        this.showSuggestions = this.employeeSuggestions.length > 0
      },
  
      selectEmployee(employee) {
        this.selectedPayslipEmployee = employee
        this.payslipName = employee.name
        this.showSuggestions = false
      },
  
      // Calculation Methods
      calculateSSS() {
        return this.selectedPayslipEmployee.amount * 0.045 // 4.5% of salary
      },
  
      calculatePhilHealth() {
        return this.selectedPayslipEmployee.amount * 0.03 // 3% of salary
      },
  
      calculatePagIbig() {
        return 100 // Fixed amount
      },
  
      calculateTax() {
        return this.selectedPayslipEmployee.amount * 0.15 // 15% of salary
      },
  
      // PDF Generation
      printPayslipToPDF() {
        const element = this.$refs.payslipContent
        const opt = {
          margin: 1,
          filename: `payslip_${this.selectedPayslipEmployee.name}_${new Date().toISOString().slice(0,10)}.pdf`,
          image: { type: 'jpeg', quality: 0.98 },
          html2canvas: { scale: 2 },
          jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
        }
  
        html2pdf().set(opt).from(element).save()
      },
  
      // Payment Actions
      resendPayment() {
        // Implement resend logic here
        alert('Payment resend initiated')
        this.closeDetailsModal()
      }
    }
  }
  </script>
  <style scoped>
  /* Base Container Styles */
  .payment-container {
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
    width: 100%;
    min-height: 100vh;
    padding: 20px;
    box-sizing: border-box;
  }
  
  /* Header Styles */
  .header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 2rem;
    margin-bottom: 2rem;
  }
  
  .header-section h1 {
    color: white;
    font-size: 1.8rem;
    margin: 0;
  }
  
  .suggestion-item{
    color: #660066;
  }
  /* Search and Filter Styles */
  .search-section {
    display: flex;
    gap: 1rem;
    padding: 1rem 2rem;
    background: white;
    margin: 0 1rem 2rem 1rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  }
  
  .search-box,
  .filter-box,
  .date-filter {
    flex: 1;
    min-width: 200px;
  }
  
  .purple-input,
  .purple-select {
    width: 100%;
    padding: 0.8rem;
    border: 2px solid #e6ccff;
    border-radius: 8px;
    font-size: 1em;
    color: #660066;
    background-color: white;
    transition: all 0.3s ease;
  }
  
  .purple-input:focus,
  .purple-select:focus {
    border-color: #cc66ff;
    outline: none;
    box-shadow: 0 0 0 3px rgba(204, 102, 255, 0.2);
  }
  
  /* Table Styles */
  .table-container {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    margin: 0 1rem;
    overflow-x: auto;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
  }
  
  th, td {
    padding: 1rem;
    text-align: left;
    border-bottom: 1px solid #e1e4e8;
    color: #660066;
  }
  
  th {
    background: #f8fafc;
    font-weight: 600;
    color: #2d3748;
  }
  
  /* Status Badge Styles */
  .status {
    padding: 0.25rem 0.75rem;
    border-radius: 15px;
    font-size: 0.875rem;
    font-weight: 500;
  }
  
  .status.sent {
    background: #e6f4ea;
    color: #1e7e34;
  }
  
  .status.failed {
    background: #feeced;
    color: #dc3545;
  }
  
  .status.returned {
    background: #fff3cd;
    color: #856404;
  }
  
  .status.pending {
    background: #e8eaed;
    color: #636363;
  }
  
  /* Modal Styles */
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
  
  .modal-content {
    background: white;
    padding: 2rem;
    border-radius: 10px;
    width: 500px;
    max-width: 90%;
    max-height: 90vh;
    overflow-y: auto;
  }
  
  /* Payslip Styles */
  .payslip-modal {
    width: 800px;
    max-width: 95%;
  }
  
  .payslip-preview {
    background: white;
    padding: 2rem;
    margin: 1rem 0;
    border: 1px solid #e1e4e8;
  }
  
  .payslip-header {
    text-align: center;
    margin-bottom: 2rem;
    padding-bottom: 1rem;
    border-bottom: 2px solid #660066;
    color:#660066;
  }
  
  .payslip-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 2rem;
    margin-bottom: 2rem;
  }
  h3, h2, span.label, value{
    color:#660066
  }
  .info-section h3 {
    color: #660066;
    margin-bottom: 1rem;
  }
  
  .info-row {
    display: flex;
    margin-bottom: 0.5rem;
    color:#660066;
  }
  
  .info-row .label {
    font-weight: 500;
    width: 120px;
  }
  
  .payslip-section {
    margin-bottom: 2rem;
  }
  
  .payslip-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 0.5rem;
  }
  
  .payslip-table th,
  .payslip-table td {
    padding: 0.75rem;
    border: 1px solid #e1e4e8;
    color: #660066;
  }
  
  .net-pay {
    background: #f8fafc;
    padding: 1rem;
    border-radius: 8px;
  }
  
  /* Button Styles */
  .generate-btn,
  .print-btn {
    background: linear-gradient(135deg, #cc66ff, #660066);
    color: white;
    border: none;
    padding: 0.6rem 1.2rem;
    border-radius: 5px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-weight: 500;
    transition: all 0.3s ease;
  }
  
  .generate-btn:hover,
  .print-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(102, 0, 102, 0.2);
  }
  
  .form-buttons {
    display: flex;
    gap: 1rem;
    margin-top: 1.5rem;
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
  
  /* Responsive Styles */
  @media (max-width: 768px) {
    .content-wrapper {
      padding: 10px;
    }
  
    .search-section {
      flex-direction: column;
      padding: 1rem;
    }
  
    .search-box,
    .filter-box,
    .date-filter {
      width: 100%;
      min-width: unset;
    }
  
    .payslip-grid {
      grid-template-columns: 1fr;
    }
  
    .header-section {
      flex-direction: column;
      gap: 1rem;
      text-align: center;
    }
  
    .generate-btn {
      width: 100%;
    }
  }
  </style>