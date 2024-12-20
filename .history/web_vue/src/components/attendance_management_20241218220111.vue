<template>
    <div class="attendance-container">
      <div class="wave-bg"></div>
      
      <div class="content-wrapper">
        <!-- Header Section -->
        <div class="header-section">
          <h1>Attendance Management</h1>
        </div>
  
        <!-- Search and Filter Section -->
        <div class="search-section">
          <div class="search-box">
            <input 
              type="text" 
              v-model="searchQuery" 
              placeholder="Search employee..."
            >
          </div>
          <div class="filter-box">
            <select v-model="selectedYear">
              <option value="2024">2024</option>
              <option value="2023">2023</option>
              <option value="2022">2022</option>
              <option value="2021">2021</option>
            </select>
          </div>
        </div>
  
        <!-- Months Grid -->
        <div class="months-grid" v-if="!showRecords">
          <!-- First Row -->
          <div class="month-row">
            <button 
              v-for="month in months.slice(0, 6)" 
              :key="month.id"
              class="month-btn"
              :class="{ active: selectedMonth === month.id }"
              @click="selectMonth(month)"
            >
              <div class="month-content">
                <span class="month-name">{{ month.name }}</span>
                <span class="attendance-count">{{ month.attendanceCount }} Records</span>
              </div>
            </button>
          </div>
          
          <!-- Second Row -->
          <div class="month-row">
            <button 
              v-for="month in months.slice(6, 12)" 
              :key="month.id"
              class="month-btn"
              :class="{ active: selectedMonth === month.id }"
              @click="selectMonth(month)"
            >
              <div class="month-content">
                <span class="month-name">{{ month.name }}</span>
                <span class="attendance-count">{{ month.attendanceCount }} Records</span>
              </div>
            </button>
          </div>
        </div>
  
        <!-- Attendance Records Table -->
        <div class="records-section" v-if="showRecords">
          <div class="records-header">
            <button class="back-btn" @click="showRecords = false">
              <span>←</span> Back to Months
            </button>
            <h2>{{ selectedMonthName }} {{ selectedYear }} Attendance Records</h2>
          </div>
  
          <div class="table-container">
            <table>
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Employee ID</th>
                  <th>Name</th>
                  <th>Time In</th>
                  <th>Time Out</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="record in filteredRecords" :key="record.id">
                  <td>{{ record.date }}</td>
                  <td>{{ record.employeeId }}</td>
                  <td>{{ record.name }}</td>
                  <td>{{ record.timeIn }}</td>
                  <td>{{ record.timeOut }}</td>
                  <td>
                    <span :class="['status', record.status.toLowerCase()]">
                      {{ record.status }}
                    </span>
                  </td>
                  <td class="actions">
                    <button @click="editRecord(record)" class="edit-btn">
                      <i class="fas fa-edit"></i>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
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
  /* ... Previous styles remain the same ... */
  
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