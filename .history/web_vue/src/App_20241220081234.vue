<template>
  <div id="app">
    <Sidebar v-if="showSidebar" />
    <router-view />
  </div>
</template><script>
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

.router-view {
  margin-left: v-bind('showSidebar ? "250px" : "0"');
  width: 100%;
}
</style>