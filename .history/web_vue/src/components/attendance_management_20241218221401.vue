<!-- Only showing the changed parts -->

<!-- Move the report section inside the records-section -->
<template>
    <!-- ... other code ... -->
    
    <!-- Attendance Records Table -->
    <div class="records-section" v-if="showRecords">
      <div class="records-header">
        <button class="back-btn" @click="showRecords = false">
          <span>←</span> Back to Months
        </button>
        <h2>{{ selectedMonthName }} {{ selectedYear }} Attendance Records</h2>
        
        <!-- Moved the report button here -->
        <button class="report-btn" @click="showReportModal = true">
          <i class="fas fa-file-alt"></i> Generate Report
        </button>
      </div>
  
      <!-- ... rest of the records table ... -->
    </div>
  </template>
  
  <style scoped>
  /* Update these styles */
  .records-header {
    display: flex;
    align-items: center;
    justify-content: space-between; /* Changed to space-between */
    padding: 1rem 0;
    margin-bottom: 1rem;
  }
  
  .report-btn {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    background: #6b2c91;
    color: white; /* Changed to white */
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-weight: 500;
  }
  
  .report-btn:hover {
    background: #5a2578;
    transform: translateY(-1px);
  }
  
  /* Remove these sections as they're no longer needed */
  .report-section {
    /* Remove this section */
  }
  
  .report-buttons {
    /* Remove this section */
  }
  
  /* Update modal styles to ensure it's always visible */
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
    position: relative; /* Added */
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Added */
  }
  
  /* Add some spacing in the records section */
  .records-section {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    height: calc(100vh - 200px); /* Adjust based on your header height */
    overflow: auto;
  }
  
  .table-container {
    flex: 1;
    overflow: auto;
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  }
  
  /* Make sure the back button and title are properly styled */
  .back-btn {
    padding: 0.5rem 1rem;
    background: #6b2c91;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  
  .records-header h2 {
    margin: 0;
    color: #2d3748;
    font-size: 1.5rem;
  }
  </style>