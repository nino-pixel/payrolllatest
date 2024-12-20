<template>
  <div class="app">
    <Sidebar />
    <div class="main-content" :class="{ 'with-sidebar': !$route.meta.fullscreen }">
      <router-view></router-view>
    </div>
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
.app {
  display: flex;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  padding: 20px;
  margin-left: 250px; /* Match sidebar width */
  min-height: 100vh;
  background: #f5f5f5;
  transition: margin-left 0.3s ease;
}

/* When sidebar is collapsed */
.sidebar.collapsed + .main-content {
  margin-left: 60px;
}

@media (max-width: 768px) {
  .main-content {
    margin-left: 60px;
    padding: 15px;
  }

  .sidebar.collapsed + .main-content {
    margin-left: 0;
  }
}
</style>