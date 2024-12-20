<template>
  <div class="layout">
    <div
      class="sidebar"
      :class="{ collapsed: isCollapsed }"
      :style="{ left: isSidebarVisible ? '0' : '-250px' }"
    >
      <div class="sidebar-header">
        <img src="../assets/payroll_logo.png" alt="PayrollEmp" class="logo" />
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
          <router-link to="/salary_adjustment" class="nav-item">
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
          <router-link to="/mark_attendance_manually" class="nav-item">
            <i class="fas fa-clock"></i>
            <span v-if="!isCollapsed">Mark Attendance</span>
          </router-link>
        </div>

        <div class="nav-group">
          <div class="nav-group-title" v-if="!isCollapsed">Payroll</div>
          <router-link to="/generate_payroll" class="nav-item">
            <i class="fas fa-file-invoice-dollar"></i>
            <span v-if="!isCollapsed">Generate Payroll</span>
          </router-link>
          <router-link to="/view_payment_history" class="nav-item">
            <i class="fas fa-history"></i>
            <span v-if="!isCollapsed">Payment History</span>
          </router-link>
        </div>

        <router-link to="/reports_and_analytics" class="nav-item">
          <i class="fas fa-chart-bar"></i>
          <span v-if="!isCollapsed">Reports & Analytics</span>
        </router-link>
      </nav>

      <div class="sidebar-footer">
        <div class="minimize-btn-container">
          <button class="collapse-btn" @click="toggleSidebar">
            <i :class="isCollapsed ? 'fas fa-chevron-right' : 'fas fa-chevron-left'"></i>
          </button>
        </div>

        <div class="logout-container">
          <button class="logout-btn" @click="handleLogout">
            <i class="fas fa-sign-out-alt"></i>
            <span v-if="!isCollapsed">Logout</span>
          </button>
        </div>
      </div>
    </div>

    <div class="content" :class="{ expanded: isCollapsed }">
      <router-view />
    </div>
  </div>
</template>

<script>
export default {
  name: "Sidebar",
  data() {
    return {
      isCollapsed: false,
      isSidebarVisible: true,
    };
  },
  watch: {
    $route(to) {
      const noSidebarRoutes = ["/login", "/signup"];
      this.isSidebarVisible = !noSidebarRoutes.includes(to.path);
    },
  },
  methods: {
    toggleSidebar() {
      this.isCollapsed = !this.isCollapsed;
    },
    handleLogout() {
      if (confirm("Are you sure you want to logout?")) {
        localStorage.removeItem("token");
        localStorage.removeItem("user");
        this.$router.push("/login");
      }
    },
  },
  mounted() {
    const noSidebarRoutes = ["/login", "/signup"];
    this.isSidebarVisible = !noSidebarRoutes.includes(this.$route.path);
  },
};
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
  z-index: 100;
  display: flex;
  flex-direction: column;
}


.sidebar.collapsed {
  width: 60px; /* Minimized width */
}

.sidebar-header {
  padding: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  min-height: 50px;
}
.content {
  margin-left: 250px;
  transition: margin-left 0.3s ease;
  width: calc(100% - 250px);
}
.content.expanded {
  margin-left: 60px;
  width: calc(100% - 60px);
}
.logo {
  height: 45px;
  width: 45px;
  border-radius: 360%;
}

.sidebar-nav {
  padding: 0.3rem 0;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 0.3rem 1rem;
  color: white;
  text-decoration: none;
  transition: all 0.3s ease;
  gap: 0.75rem;
  height: 32px;
  font-size: 0.85rem;
}
.nav-item:hover {
  background: rgba(255, 255, 255, 0.1);
}
.nav-item i {
  width: 20px;
  text-align: center;
  font-size: 0.9rem;
}

.sidebar-footer {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  margin-top: auto;
}

.minimize-btn-container {
  height: 32px;
  padding: 0.3rem;
  display: flex;
  justify-content: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}
.collapse-btn {
  background: none;
  border: none;
  color: white;
  cursor: pointer;
  width: 100%;
  height: 32px;
  transition: all 0.3s ease;
}
.layout {
  display: flex;
  width: 100%;
  height: 100vh;
}
@media (max-width: 768px) {
  .sidebar {
    width: 60px;
  }

  
}
</style>
