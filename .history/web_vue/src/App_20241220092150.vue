<template>
  <div id="app">
    <Sidebar v-if="showSidebar" />
    <router-view />
  </div>
</template>

<script>
import Sidebar from './components/Sidebar.vue'

export default {
  name: 'App',
  components: {
    Sidebar
  },
  computed: {
    showSidebar() {
      // Don't show sidebar on login or signup pages
      const noSidebarRoutes = ['/login', '/signup']
      return !noSidebarRoutes.includes(this.$route.path)
    }
  }
}
</script>

<style>
#app {
  display: flex;
}

.main-content {
  flex: 1;
  transition: margin-left 0.3s ease;
}

.main-content.with-sidebar {
  margin-left: 250px; /* Match your sidebar width */
}

@media (max-width: 768px) {
  .main-content.with-sidebar {
    margin-left: 60px; /* Match your collapsed sidebar width */
  }
  .dashboard-container,
.employee-container,
.payroll-container,
.reports-container,
.salary-container,
.payment-container {
  margin-left: 250px; /* Same as sidebar width */
  transition: margin-left 0.3s ease;
  width: calc(100% - 250px);
}
/* Adjust margin when sidebar is collapsed */
.sidebar.collapsed ~ .dashboard-container,
.sidebar.collapsed ~ .employee-container,
.sidebar.collapsed ~ .payroll-container,
.sidebar.collapsed ~ .reports-container,
.sidebar.collapsed ~ .salary-container,
.sidebar.collapsed ~ .payment-container {
  margin-left: 60px;
  width: calc(100% - 60px);
}

/* Mobile responsive adjustments */
@media (max-width: 768px) {
  .dashboard-container,
  .employee-container,
  .payroll-container,
  .reports-container,
  .salary-container,
  .payment-container {
    margin-left: 60px;
    width: calc(100% - 60px);
  }

  .sidebar.collapsed ~ .dashboard-container,
  .sidebar.collapsed ~ .employee-container,
  .sidebar.collapsed ~ .payroll-container,
  .sidebar.collapsed ~ .reports-container,
  .sidebar.collapsed ~ .salary-container,
  .sidebar.collapsed ~ .payment-container {
    margin-left: 0;
    width: 100%;
  }
}
}
</style>