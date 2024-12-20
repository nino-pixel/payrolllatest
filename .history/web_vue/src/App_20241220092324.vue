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
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

#app {
  font-family: Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  display: flex;
  min-height: 100vh;
  background: #f5f5f5;
}

.main-content {
  flex: 1;
  min-height: 100vh;
  transition: margin-left 0.3s ease;
}

/* Add margin when sidebar is present */
.main-content.with-sidebar {
  margin-left: 250px; /* Same as sidebar width */
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .main-content.with-sidebar {
    margin-left: 60px; /* Same as collapsed sidebar width */
  }
}

/* Global styles for consistent look */
button {
  cursor: pointer;
}

input, button {
  font-family: inherit;
}

/* Transition effects */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}

/* Optional: Add scrollbar styling */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
}

::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #555;
}
.router-view {
  margin-left: v-bind(showSidebar ? '250px' : '0');
  width: 100%;
}
</style>