<template>
  <div id="app">
    <Sidebar />
    <router-view />
  </div>
</template>

<script>
import Sidebar from './components/Sidebar.vue'

export default {
  name: 'App',
  components: {
    Sidebar
  }
}
</script>
<style>
/* App styling remains mostly the same */

#app {
  font-family: Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  transition: margin-left 0.3s ease;
  min-height: 100vh;
}

/* When sidebar is visible and not collapsed */
.main-content.with-sidebar {
  margin-left: 250px; /* Sidebar expanded width */
}

/* When sidebar is collapsed */
.main-content.with-sidebar.collapsed {
  margin-left: 60px; /* Sidebar collapsed width */
}

@media (max-width: 768px) {
  .main-content.with-sidebar {
    margin-left: 60px; /* Adjust for smaller screens */
  }

  .main-content.with-sidebar.collapsed {
    margin-left: 0;
  }
}
</style>
