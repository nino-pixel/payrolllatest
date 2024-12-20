
<template>
  
</template>

<script>
import login_page from './components/login_page.vue'  // Import the component

export default {
  name: 'App',
  components: {
    login_page  // Register the component
  }
} 
</script>
<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
