
<template>
 <router-view></router-view>
  
</template>

<script>
import sign_up from './components/sign_up.vue'  // Import the component
 // Import the component

export default {
  name: 'App',
  components: {
    sign_up  // Register the component
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
