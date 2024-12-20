 
  .content {
    margin-left: 60px;
    width: calc(100% - 60px);
  }
  
  .sidebar.collapsed {
    width: 0;
    overflow: hidden;
  }
  
  .content.expanded {
    margin-left: 0;
    width: 100%;
  }

<style>
/* App styling remains mostly the same */

#app {
  font-family: Arial, sans-serif;
  display: flex;
  min-height: 100vh;
  background: #f5f5f5;
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
