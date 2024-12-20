<template>
  <div class="sidebar" :class="{ 'collapsed': isCollapsed }">
    <div class="sidebar-header">
      <h2 v-if="!isCollapsed">My App</h2>
      <h2 v-else>M</h2>
    </div>
    <ul class="sidebar-menu">
      <li v-for="item in menuItems" :key="item.name" class="menu-item">
        <router-link :to="item.path" class="menu-link">
          <i :class="item.icon"></i>
          <span v-if="!isCollapsed">{{ item.name }}</span>
        </router-link>
      </li>
    </ul>
    <button class="collapse-btn" @click="toggleSidebar">
      <i :class="isCollapsed ? 'fas fa-chevron-right' : 'fas fa-chevron-left'"></i>
    </button>
  </div>
</template>

<script>
export default {
  name: 'Sidebar',
  props: {
    isCollapsed: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      menuItems: [
        { name: 'Home', path: '/', icon: 'fas fa-home' },
        { name: 'Profile', path: '/profile', icon: 'fas fa-user' },
        { name: 'Settings', path: '/settings', icon: 'fas fa-cog' }
      ]
    };
  },
  methods: {
    toggleSidebar() {
      this.$emit('toggle');
    }
  }
};
</script>

<style scoped>
.sidebar {
  width: 250px;
  background: #333;
  color: #fff;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  transition: width 0.3s ease;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.sidebar.collapsed {
  width: 60px;
}

.sidebar-header {
  padding: 20px;
  text-align: center;
  font-size: 1.5rem;
  background: #444;
  border-bottom: 1px solid #555;
}

.sidebar-menu {
  list-style: none;
  padding: 0;
  margin: 0;
  flex: 1;
}

.menu-item {
  margin: 10px 0;
}

.menu-link {
  display: flex;
  align-items: center;
  padding: 10px 20px;
  color: #fff;
  text-decoration: none;
  transition: background 0.3s ease;
}

.menu-link:hover {
  background: #444;
}

.menu-link i {
  margin-right: 10px;
  font-size: 1.2rem;
}

.sidebar.collapsed .menu-link span {
  display: none;
}

.collapse-btn {
  background: #444;
  border: none;
  color: #fff;
  font-size: 1.2rem;
  padding: 10px;
  cursor: pointer;
  transition: background 0.3s ease;
}

.collapse-btn:hover {
  background: #555;
}

.collapse-btn i {
  font-size: 1rem;
}
</style>
