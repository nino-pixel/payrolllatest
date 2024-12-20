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
        showPayslipModal: false,
        payslipName: '',
        selectedPayslipEmployee: null,
        showSuggestions: false,
        employeeSuggestions: [],
        latestSalary: 0,
        latestPaymentDate: '',
        
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
      },
      openPayslipModal() {
        this.showPayslipModal = true;
        this.payslipName = '';
        this.selectedPayslipEmployee = null;
      },
      closePayslipModal() {
        this.showPayslipModal = false;
        this.payslipName = '';
        this.selectedPayslipEmployee = null;
        this.showSuggestions = false;
      },
      searchEmployee() {
        if (this.payslipName.length < 2) {
          this.showSuggestions = false;
          return;
        }
        
        // Filter employees based on name input
        this.employeeSuggestions = this.payments
          .filter(emp => emp.name.toLowerCase().includes(this.payslipName.toLowerCase()))
          .filter(emp => emp.status === 'Sent');
        
        this.showSuggestions = this.employeeSuggestions.length > 0;
      },
      selectEmployee(employee) {
        this.selectedPayslipEmployee = employee;
        this.payslipName = employee.name;
        this.showSuggestions = false;
        
        // Find latest successful payment
        const latestPayment = this.payments
          .filter(p => p.name === employee.name && p.status === 'Sent')
          .sort((a, b) => new Date(b.date) - new Date(a.date))[0];
        
        if (latestPayment) {
          this.latestSalary = latestPayment.amount;
          this.latestPaymentDate = latestPayment.date;
        }
      },
      generatePayslip() {
        // Implement payslip generation logic here
        console.log('Generating payslip for:', this.selectedPayslipEmployee);
        this.closePayslipModal();
      }
    }
  }
  </script>
  
  <style scoped>
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
  
  /* Reuse existing styles from employee_management.vue */
  .content-wrapper {
    position: relative;
  z-index: 1;
  min-height: 100vh;
  width: 100%;
  padding: 20px;
}
  
.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  width: 100%;
}
  .table-container {
    background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  width: 100%;
  margin-top: 1rem;
}
.table-container {
    margin: 0.5rem;
  }
  .search-section {
    flex-direction: column;

    padding: 1rem;
  }
  .header-section h1 {
    color: white;
    font-size: 1.8rem;
    margin: 0;
  }
  table {
    width: 100%;
    border-collapse: collapse;/* Ensures table doesn't get too cramped */
}
.search-box,
  .filter-box,
  .date-filter {
    width: 100%;
  }
  .attendance-container {
  min-height: 100vh;
  width: 100%;  /* Changed from 100vw to prevent horizontal scroll */
  padding: 0;
  margin: 0;
  background: #f2e6ff;
  position: relative;
  overflow-x: hidden;
}
th, td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid #e1e4e8;
}
th {
  background: #f8fafc;
  font-weight: 600;
  color: #2d3748;
}
.search-section {
    display: flex;
  gap: 1rem;
  width: 100%;
  margin-bottom: 1rem;
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
    margin-top: 1.5rem;
    padding-top: 1.5rem;
    border-top: 1px solid #e1e4e8;
  }
  
  .summary-section h3 {
    color: #2d3748;
    margin-bottom: 0.5rem;
  }
  
  .summary-section p {
    color: #4a5568;
    line-height: 1.5;
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
  
  .submit-btn:hover,
  .cancel-btn:hover {
    opacity: 0.9;
    transform: translateY(-1px);
  }
  
  /* Generate Payslip Modal Styles */
  .payslip-modal {
    width: 600px;
    max-width: 90%;
  }
  
  .form-group {
    margin-bottom: 1.5rem;
    position: relative;
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
  
  .payslip-details {
    display: grid;
    gap: 1rem;
    margin: 1.5rem 0;
  }
  
  .detail-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .detail-group label {
    color: #660066;
    font-weight: 500;
  }
  
  .generate-btn {
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
  
  .generate-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(102, 0, 102, 0.2);
  }
  
  @media (max-width: 768px) {
  .content-wrapper {
    padding: 10px;
  }
    
    .search-box,
    .filter-box,
    .date-filter {
      width: 100%;
    }
  }
  </style> 
