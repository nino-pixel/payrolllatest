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
    <!-- Generate Payslip Modal -->
    <div class="modal" v-if="showPayslipModal">
        <div class="modal-content payslip-modal">
          <h2>Generate Payslip</h2>
          
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

          <!-- Auto-filled Details -->
          <div class="payslip-details" v-if="selectedPayslipEmployee">
            <div class="detail-group">
              <label>Employee ID</label>
              <input type="text" :value="selectedPayslipEmployee.id" disabled class="purple-input">
            </div>
            <div class="detail-group">
              <label>Department</label>
              <input type="text" :value="selectedPayslipEmployee.department" disabled class="purple-input">
            </div>
            <div class="detail-group">
              <label>Position</label>
              <input type="text" :value="selectedPayslipEmployee.position" disabled class="purple-input">
            </div>
            <div class="detail-group">
              <label>Latest Salary</label>
              <input type="text" :value="'₱' + formatCurrency(latestSalary)" disabled class="purple-input">
            </div>
            <div class="detail-group">
              <label>Payment Date</label>
              <input type="text" :value="formatDate(latestPaymentDate)" disabled class="purple-input">
            </div>
          </div>

          <!-- Buttons -->
          <div class="form-buttons">
            <button 
              class="submit-btn" 
              @click="generatePayslip"
              :disabled="!selectedPayslipEmployee"
            >
              Generate
            </button>
            <button class="cancel-btn" @click="closePayslipModal">
              Cancel
            </button>
          </div>
        </div>
      </div>
      <!-- Details Modal -->
      <div class="modal" v-if="showModal">
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
              <button class="cancel-btn" @click="closeModal">Cancel</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'ViewPaymentHistory',
    data() {
      return {
        searchQuery: '',
        departmentFilter: '',
        dateFilter: '',
        showModal: false,
        selectedPayment: null,
        payslipName: '',
      selectedPayslipEmployee: null,
      showSuggestions: false,
      employeeSuggestions: [],
      latestSalary: 0,
      latestPaymentDate: null
      }
        payments: [
          {
            id: 1,
            name: 'John Doe',
            department: 'IT',
            amount: 25000,
            date: '2024-02-15',
            status: 'Sent',
            summary: ''
          },
          {
            id: 2,
            name: 'Jane Smith',
            department: 'HR',
            amount: 30000,
            date: '2024-02-15',
            status: 'Failed',
            summary: 'Transaction failed due to invalid bank account details. Please verify the banking information and try again.'
          },
          {
            id: 3,
            name: 'Mike Johnson',
            department: 'Finance',
            amount: 35000,
            date: '2024-02-15',
            status: 'Returned',
            summary: 'Payment returned by the bank due to account restrictions. Please contact the employee to update their banking information.'
          }
        ]
      }
    },
    computed: {
        filteredPayments() {
      return this.payments.filter(payment => {
        const matchesName = payment.name.toLowerCase()
          .includes(this.searchQuery.toLowerCase());
        const matchesDepartment = !this.departmentFilter || 
          payment.department === this.departmentFilter;
        const matchesDate = !this.dateFilter || 
          payment.date.startsWith(this.dateFilter);
        
        return matchesName && matchesDepartment && matchesDate;
      });
    }
    },
    methods: {
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
      isClickableStatus(status) {
        return ['Failed', 'Returned'].includes(status)
      },
      showDetails(payment) {
        if (this.isClickableStatus(payment.status)) {
          this.selectedPayment = payment
          this.showModal = true
        }
      },
      closeModal() {
        this.showModal = false
        this.selectedPayment = null
      },
      resendPayment() {
        // Implement resend logic here
        alert('Payment resend initiated')
        this.closeModal()
      }
    }
  }
  </script>
  
  <style scoped>
  .payment-container {
    width: 100vw;
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
  
  /* Reuse existing styles from employee_management.vue */
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
  
  .search-section {
  display: flex;
  gap: 1rem;
  padding: 1rem 2rem;
  align-items: center;
  flex-wrap: wrap;
}
  
  .filter-box, .date-filter {
    flex: 1;
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
  .purple-select, .purple-input {
    width: 100%;
    padding: 0.6rem;
    border: 1px solid #cc66ff;
    border-radius: 5px;
    background-color: #f2e6ff;
    color: #9737e0;
    font-weight: 600;
  }
  
  /* Status styles */
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
  
  /* Modal styles */
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
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  }
  
  .summary-section {
    margin: 1.5rem 0;
    padding: 1rem;
    background: #f8f9fa;
    border-radius: 5px;
  }
  
  .summary-section h3 {
    color: #6b2c91;
    margin-bottom: 0.5rem;
  }
  
  .summary-section p {
    color: #4a5568;
    line-height: 1.5;
  }
  
  /* Button styles */
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
  
  /* Table styles */
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
  
  @media (max-width: 768px) {
  .search-section {
    flex-direction: column;
    padding: 1rem;
  }
    .filter-box,
    .date-filter {
      width: 100%;
    }
    .search-box,
  .filter-box,
  .date-filter {
    width: 100%;
    min-width: unset;
  }
    .table-container {
      margin: 0.5rem;
      padding: 0.5rem;
    }
  }
  </style>