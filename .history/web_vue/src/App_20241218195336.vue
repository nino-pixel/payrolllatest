
<template>
 <router-view></router-view>
  
</template>

<script>
import login_page from './components/login_page.vue' 
 // Import the component

export default {
  name: 'App',
  components: {
    login_page,
  }
} 
</script>
<style scoped>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body, html {
    height: 100%;
    width: 100%;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
}

#app {
    min-height: 100vh;
    width: 100%;
}
</style>
