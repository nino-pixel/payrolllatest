<template>
  <div class="sidebar" :class="{ 'collapsed': isCollapsed }">
    <!-- Sidebar content -->
    <button class="collapse-btn" @click="handleToggle">
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
  methods: {
    handleToggle() {
      this.$emit('toggle'); // Emit event to parent to update collapse state
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
  z-index: 100;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
  .sidebar.collapsed {
    width: 60px;
  }
  

  .sidebar-header {
  padding: 0.5rem; /* Reduced padding */
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  min-height: 50px; /* Reduced height */
}
.logo {
  height: 45px; /* Smaller logo */
  width: 45px;
  border-radius: 360%;
}
  
.sidebar-nav {
  padding: 0.3rem 0; /* Reduced padding */
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.2rem; /* Add small gap between items */
}
  
.nav-group {
  margin-bottom: 0.3rem; /* Reduced margin */
}
  
.nav-group-title {
  padding: 0.2rem 1rem; /* Reduced padding */
  font-size: 0.7rem; /* Smaller font */
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.6);
}
  
.nav-item {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  padding: 0.3rem 1rem; /* Reduced padding */
  color: white;
  text-decoration: none;
  transition: all 0.3s ease;
  gap: 0.75rem;
  height: 32px; /* Reduced height */
  font-size: 0.85rem; /* Slightly smaller font */
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
    font-size: 0.9rem; /* Smaller icons */
}
  
  .nav-item span {
    font-size: 0.85rem;
    white-space: nowrap;
  }
  
  .sidebar-footer {
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    margin-top: auto;
  }
  
  .minimize-btn-container {
  height: 32px; /* Reduced height */

    padding: 0.3rem; /* Reduced padding */
    display: flex;
    justify-content: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }
  
  .collapse-btn {
    background: none;
    border: none;
    color: white;
    cursor: pointer;
    padding: 0.3rem;
    width: 100%;
    height: 32px; /* Reduced height */
    transition: all 0.3s ease;
  }
  
  .collapse-btn:hover {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 4px;
  }
  
  .logout-container {
    padding: 0.3rem; /* Reduced padding */
}
  
  .logout-btn {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.4rem 1rem; /* Reduced padding */
    background: rgba(220, 53, 69, 0.1);
    border: none;
    border-radius: 4px;
    color: #fff;
    cursor: pointer;
    transition: all 0.3s ease;
  height: 32px; /* Reduced height */
  font-size: 0.85rem;

  }
  
  .logout-btn:hover {
    background: rgba(220, 53, 69, 0.2);
  }
  
  .logout-btn i {
    width: 20px;
    text-align: center;
  font-size: 0.9rem; /* Smaller icon */

  }
  
  .sidebar.collapsed .logout-btn span {
    display: none;
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