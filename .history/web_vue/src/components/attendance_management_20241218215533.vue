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
        <div class="months-grid">
          <!-- First Row -->
          <div class="month-row">
            <button 
              v-for="month in months.slice(0, 6)" 
              :key="month.id"
              class="month-btn"
              :class="{ active: selectedMonth === month.id }"
              @click="selectMonth(month.id)"
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
              @click="selectMonth(month.id)"
            >
              <div class="month-content">
                <span class="month-name">{{ month.name }}</span>
                <span class="attendance-count">{{ month.attendanceCount }} Records</span>
              </div>
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
        ]
      }
    },
    methods: {
      selectMonth(monthId) {
        this.selectedMonth = monthId
        // Add your logic here for when a month is selected
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
  </style>