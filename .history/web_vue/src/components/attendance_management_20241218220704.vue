<template>
    <div class="attendance-container">
      <!-- ... existing header and search sections ... -->
  
      <!-- Report Generation Section -->
      <div class="report-section" v-if="showRecords">
        <div class="report-buttons">
          <button class="report-btn" @click="showReportModal = true">
            <i class="fas fa-file-alt"></i> Generate Report
          </button>
        </div>
      </div>
  
      <!-- ... existing months grid and records table ... -->
  
      <!-- Report Generation Modal -->
      <div class="modal" v-if="showReportModal">
        <div class="modal-content">
          <h2>Generate Attendance Report</h2>
          
          <div class="report-options">
            <div class="form-group">
              <label>Report Type</label>
              <select v-model="reportSettings.type">
                <option value="monthly">Monthly Report</option>
                <option value="status">Status Report</option>
                <option value="employee">Employee Report</option>
              </select>
            </div>
  
            <!-- Monthly Report Options -->
            <div class="form-group" v-if="reportSettings.type === 'monthly'">
              <label>Select Month</label>
              <select v-model="reportSettings.month">
                <option v-for="month in months" :key="month.id" :value="month.id">
                  {{ month.name }}
                </option>
              </select>
            </div>
  
            <!-- Status Report Options -->
            <div class="form-group" v-if="reportSettings.type === 'status'">
              <label>Select Status</label>
              <select v-model="reportSettings.status">
                <option value="present">Present</option>
                <option value="absent">Absent</option>
                <option value="late">Late</option>
                <option value="all">All Statuses</option>
              </select>
            </div>
  
            <!-- Employee Report Options -->
            <div class="form-group" v-if="reportSettings.type === 'employee'">
              <label>Select Employee</label>
              <select v-model="reportSettings.employeeId">
                <option v-for="emp in employees" :key="emp.id" :value="emp.id">
                  {{ emp.name }}
                </option>
              </select>
            </div>
  
            <div class="form-group">
              <label>Date Range</label>
              <div class="date-range">
                <input type="date" v-model="reportSettings.startDate">
                <span>to</span>
                <input type="date" v-model="reportSettings.endDate">
              </div>
            </div>
  
            <div class="form-group">
              <label>File Format</label>
              <select v-model="reportSettings.format">
                <option value="pdf">PDF</option>
                <option value="excel">Excel</option>
                <option value="csv">CSV</option>
              </select>
            </div>
          </div>
  
          <div class="form-buttons">
            <button class="generate-btn" @click="generateReport">
              Generate Report
            </button>
            <button class="cancel-btn" @click="showReportModal = false">
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'AttendanceManagement',
    data() {
      return {
        searchQuery: '',
        selectedYear: '2024',
        selectedMonth: null,
        selectedMonthName: '',
        showRecords: false,
        months: [
          { id: 1, name: 'January', attendanceCount: 150 },
          { id: 2, name: 'February', attendanceCount: 145 },
          { id: 3, name: 'March', attendanceCount: 160 },
          { id: 4, name: 'April', attendanceCount: 155 },
          { id: 5, name: 'May', attendanceCount: 158 },
          { id: 6, name: 'June', attendanceCount: 152 },
          { id: 7, name: 'July', attendanceCount: 157 },
          { id: 8, name: 'August', attendanceCount: 159 },
          { id: 9, name: 'September', attendanceCount: 151 },
          { id: 10, name: 'October', attendanceCount: 153 },
          { id: 11, name: 'November', attendanceCount: 148 },
          { id: 12, name: 'December', attendanceCount: 156 }
        ],
        attendanceRecords: [
          // Sample data - replace with your actual data
          {
            id: 1,
            date: '2024-01-15',
            employeeId: 'EMP001',
            name: 'John Doe',
            timeIn: '08:00 AM',
            timeOut: '05:00 PM',
            status: 'Present'
          },
          // Add more records...
        ]
      }
    },
    computed: {
      filteredRecords() {
        return this.attendanceRecords.filter(record => {
          const matchesSearch = record.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                              record.employeeId.toLowerCase().includes(this.searchQuery.toLowerCase())
          return matchesSearch
        })
      }
    },
    methods: {
      selectMonth(month) {
        this.selectedMonth = month.id
        this.selectedMonthName = month.name
        this.showRecords = true
        // Here you would typically fetch the attendance records for the selected month
      },
      editRecord(record) {
        // Implement edit functionality
        console.log('Editing record:', record)
      }
    }
  }
  </script>
  <style scoped>
  .attendance-container {
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
    background: white;
    margin: 0 1rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  }
  
  .search-box input,
  .filter-box select {
    padding: 0.5rem;
    border: 1px solid #e1e4e8;
    border-radius: 5px;
    width: 200px;
    color: #4a5568;
  }
  
  .search-box input:focus,
  .filter-box select:focus {
    outline: none;
    border-color: #6b2c91;
    box-shadow: 0 0 0 2px rgba(107, 44, 145, 0.1);
  }
  
  .months-grid {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding: 1rem 2rem;
    margin: 1rem;
  }
  
  .month-row {
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    gap: 1rem;
  }
  
  .month-btn {
    background: white;
    border: none;
    border-radius: 8px;
    padding: 1.5rem;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    text-align: left;
    height: 100px;
    color:  #6b2c91;
  }
  
  .month-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  }
  
  .month-btn.active {
    background: #6b2c91;
    color: white;
  }
  
  .month-content {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .month-name {
    font-size: 1.2rem;
    font-weight: 500;
  }
  
  .attendance-count {
    font-size: 0.9rem;
    opacity: 0.8;
  }
  
  .month-btn.active .attendance-count {
    color: rgba(255, 255, 255, 0.9);
  }
  
  /* Responsive adjustments */
  @media (max-width: 1200px) {
    .month-row {
      grid-template-columns: repeat(3, 1fr);
    }
  }
  
  @media (max-width: 768px) {
    .month-row {
      grid-template-columns: repeat(2, 1fr);
    }
    
    .search-section {
      flex-direction: column;
    }
    
    .search-box input,
    .filter-box select {
      width: 100%;
    }
  }

  
.records-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  padding: 1rem 2rem;
  margin: 1rem;
}

.records-header {
  display: flex;
  align-items: center;
  gap: 2rem;
  margin-bottom: 1rem;
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background: #6b2c91;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.back-btn:hover {
  background: #5a2578;
}

.records-header h2 {
  color: #2d3748;
  margin: 0;
}

.table-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  overflow-x: auto;
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
}

th {
  background: #f8fafc;
  color: #2d3748;
  font-weight: 600;
}

td {
  color: #4a5568;
}

.status {
  padding: 0.25rem 0.75rem;
  border-radius: 15px;
  font-size: 0.875rem;
}

.status.present {
  background: #e6f4ea;
  color: #1e7e34;
}

.status.absent {
  background: #feeced;
  color: #dc3545;
}

.status.late {
  background: #fff3cd;
  color: #856404;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

.edit-btn {
  padding: 0.25rem 0.5rem;
  background: #28a745;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.edit-btn:hover {
  background: #218838;
}
  </style>