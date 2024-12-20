<template>
  <div class="attendance-container">
    <div class="wave-bg"></div>
    <h1>Manual Attendance Entry</h1>

    <!-- Alert Messages -->
    <div v-if="errorMessage" class="alert alert-error">
      <span class="close-btn" @click="errorMessage = ''">×</span>
      {{ errorMessage }}
    </div>
    <div v-if="successMessage" class="alert alert-success">
      <span class="close-btn" @click="successMessage = ''">×</span>
      {{ successMessage }}
    </div>

    <div class="form-section">
      <!-- Employee Selection -->
      <div class="form-group">
        <label>Select Employee</label>
        <select 
          v-model="selectedEmployee"
          @change="updateDepartment"
          class="purple-select"
        >
          <option value="">Choose an employee...</option>
          <option v-for="emp in employees" :key="emp.id" :value="emp.id">
            {{ emp.name }}
          </option>
        </select>
      </div>

      <!-- Department (Auto-filled) -->
      <div class="form-group">
        <label>Department</label>
        <input 
          type="text" 
          :value="selectedDepartment" 
          class="purple-input" 
          disabled
        >
      </div>

      <!-- Time In -->
      <div class="form-group">
        <label>Time In</label>
        <input 
          type="time" 
          v-model="timeIn"
          class="purple-input"
        >
      </div>

      <!-- Time Out -->
      <div class="form-group">
        <label>Time Out</label>
        <input 
          type="time" 
          v-model="timeOut"
          class="purple-input"
        >
      </div>

      <!-- Date -->
      <div class="form-group">
        <label>Date</label>
        <input 
          type="date" 
          v-model="date"
          :max="today"
          class="purple-input"
        >
      </div>

      <!-- Submit Button -->
      <button 
        @click="submitAttendance" 
        class="submit-btn"
        :disabled="!isFormValid"
      >
        Submit Attendance
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MarkAttendanceManually',
  data() {
    return {
      selectedEmployee: '',
      timeIn: '',
      timeOut: '',
      date: new Date().toISOString().split('T')[0],
      errorMessage: '',
      successMessage: '',
      employees: [
        { id: 'EMP001', name: 'John Doe', department: 'IT' },
        { id: 'EMP002', name: 'Jane Smith', department: 'HR' },
        // Add more employees as needed
      ]
    }
  },
  computed: {
    today() {
      return new Date().toISOString().split('T')[0]
    },
    selectedDepartment() {
      const employee = this.employees.find(emp => emp.id === this.selectedEmployee)
      return employee ? employee.department : ''
    },
    isFormValid() {
      return this.selectedEmployee && this.timeIn && this.timeOut && this.date
    }
  },
  methods: {
    updateDepartment() {
      // Department is automatically updated through computed property
    },
    submitAttendance() {
      try {
        // Validate time in and time out
        if (this.timeIn >= this.timeOut) {
          throw new Error('Time out must be later than time in')
        }

        // Create attendance record
        const attendanceRecord = {
          employeeId: this.selectedEmployee,
          date: this.date,
          timeIn: this.timeIn,
          timeOut: this.timeOut,
          department: this.selectedDepartment
        }

        // Here you would typically send this to your backend
        console.log('Attendance record:', attendanceRecord)
        
        this.successMessage = 'Attendance recorded successfully!'
        this.resetForm()

      } catch (error) {
        this.errorMessage = error.message
      }
    },
    resetForm() {
      this.selectedEmployee = ''
      this.timeIn = ''
      this.timeOut = ''
      this.date = new Date().toISOString().split('T')[0]
    }
  }
}
</script>

<style scoped>
.attendance-container {
  min-height: 100vh;
  padding: 0;
  background: #f2e6ff;
  position: relative;
  overflow-x: hidden;
}

.wave-bg {
  position: absolute;
  top: 0;
  left: -10%;
  right: -10%;
  height: 200px;
  background: linear-gradient(135deg, #cc66ff, #660066);
  border-radius: 0 0 50% 50%;
  z-index: 0;
}

h1 {
  padding-top: 40px;
  margin-top: 0;
  color: #660066;
  text-align: center;
  position: relative;
  z-index: 1;
  margin-bottom: 40px;
  font-size: 2.5em;
  font-weight: 600;
  text-shadow: 0 2px 4px rgba(204, 102, 255, 0.2);
}

.form-section {
  max-width: 500px;
  margin: 0 auto;
  padding: 2rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(102, 0, 102, 0.1);
  position: relative;
  z-index: 1;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #660066;
  font-weight: 500;
}

.purple-input,
.purple-select {
  width: 100%;
  padding: 12px;
  border: 2px solid #e6ccff;
  border-radius: 8px;
  font-size: 1em;
  color: #660066;
  background-color: white;
  transition: all 0.3s ease;
}

.purple-input:disabled {
  background-color: #f2e6ff;
  cursor: not-allowed;
}

.purple-input:focus,
.purple-select:focus {
  border-color: #cc66ff;
  outline: none;
  box-shadow: 0 0 0 3px rgba(204, 102, 255, 0.2);
}

.submit-btn {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(135deg, #cc66ff, #660066);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1.1em;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.submit-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.submit-btn:not(:disabled):hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(102, 0, 102, 0.2);
}

.alert {
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1rem;
  position: relative;
  text-align: center;
}

.alert-error {
  background-color: #fad8dd;
  color: #dc3545;
}

.alert-success {
  background-color: #d7fada;
  color: #28a745;
}

.close-btn {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  opacity: 0.7;
}

.close-btn:hover {
  opacity: 1;
}

@media (max-width: 768px) {
  .form-section {
    margin: 1rem;
    padding: 1.5rem;
  }
}
</style>