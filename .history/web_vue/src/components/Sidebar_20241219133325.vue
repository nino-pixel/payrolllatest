<template>
    <div class="sidebar" :class="{ 'collapsed': isCollapsed }">
      <div class="sidebar-header">
        <img src="../assets/logo.png" alt="PayrollEmp" class="logo">
        <button class="collapse-btn" @click="toggleSidebar">
          <i :class="isCollapsed ? 'fas fa-chevron-right' : 'fas fa-chevron-left'"></i>
        </button>
      </div>
  
      <nav class="sidebar-nav">
        <router-link to="/dashboard" class="nav-item">
          <i class="fas fa-chart-line"></i>
          <span v-if="!isCollapsed">Dashboard</span>
        </router-link>
  
        <div class="nav-group">
          <div class="nav-group-title" v-if="!isCollapsed">Employee Management</div>
          <router-link to="/employees" class="nav-item">
            <i class="fas fa-users"></i>
            <span v-if="!isCollapsed">Employees</span>
          </router-link>
          <router-link to="/salary-adjustment" class="nav-item">
            <i class="fas fa-money-bill-wave"></i>
            <span v-if="!isCollapsed">Salary Adjustment</span>
          </router-link>
        </div>
  
        <div class="nav-group">
          <div class="nav-group-title" v-if="!isCollapsed">Attendance</div>
          <router-link to="/attendance" class="nav-item">
            <i class="fas fa-calendar-check"></i>
            <span v-if="!isCollapsed">Attendance Management</span>
          </router-link>
          <router-link to="/mark-attendance" class="nav-item">
            <i class="fas fa-clock"></i>
            <span v-if="!isCollapsed">Mark Attendance</span>
          </router-link>
        </div>
  
        <div class="nav-group">
          <div class="nav-group-title" v-if="!isCollapsed">Payroll</div>
          <router-link to="/generate-payroll" class="nav-item">
            <i class="fas fa-file-invoice-dollar"></i>
            <span v-if="!isCollapsed">Generate Payroll</span>
          </router-link>
          <router-link to="/payment-history" class="nav-item">
            <i class="fas fa-history"></i>
            <span v-if="!isCollapsed">Payment History</span>
          </router-link>
        </div>
  
        <router-link to="/reports" class="nav-item">
          <i class="fas fa-chart-bar"></i>
          <span v-if="!isCollapsed">Reports & Analytics</span>
        </router-link>
      </nav>
    </div>
  </template>
  
  <script>
  export default {
    name: 'Sidebar',
    data() {
      return {
        isCollapsed: false
      }
    },
    methods: {
      toggleSidebar() {
        this.isCollapsed = !this.isCollapsed
      }
    }
  }
  </script>
  
  <style scoped>
  .sidebar {
    width: 250px;
    height: 100vh;
    background: linear-gradient(135deg, #660066, #cc66ff);
    color: white;
    position: fixed;
    left: 0;
    top: 0;
    transition: all 0.3s ease;
    z-index: 1000;
  }
  
  .sidebar.collapsed {
    width: 60px;
  }
  
  .sidebar-header {
    padding: 1rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }
  
  .logo {
    height: 40px;
    width: auto;
  }
  
  .collapse-btn {
    background: none;
    border: none;
    color: white;
    cursor: pointer;
    padding: 0.5rem;
  }
  
  .sidebar-nav {
    padding: 1rem 0;
  }
  
  .nav-group {
    margin-bottom: 1rem;
  }
  
  .nav-group-title {
    padding: 0.5rem 1rem;
    font-size: 0.8rem;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.6);
  }
  
  .nav-item {
    display: flex;
    align-items: center;
    padding: 0.75rem 1rem;
    color: white;
    text-decoration: none;
    transition: all 0.3s ease;
    gap: 0.75rem;
  }
  
  .nav-item:hover {
    background: rgba(255, 255, 255, 0.1);
  }
  
  .nav-item.router-link-active {
    background: rgba(255, 255, 255, 0.2);
  }
  
  .nav-item i {
    width: 20px;
    text-align: center;
  }
  
  @media (max-width: 768px) {
    .sidebar {
      width: 60px;
    }
  
    .sidebar.collapsed {
      width: 0;
      overflow: hidden;
    }
  
    .nav-group-title {
      display: none;
    }
  }
  </style>