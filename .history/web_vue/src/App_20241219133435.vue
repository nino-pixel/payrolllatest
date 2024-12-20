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
  margin-left: 250px;
  transition: all 0.3s ease;
}

.main-content.with-sidebar {
  margin-left: 60px;
}

@media (max-width: 768px) {
  .main-content {
    margin-left: 60px;
  }

  .main-content.with-sidebar {
    margin-left: 0;
  }
}
</style>