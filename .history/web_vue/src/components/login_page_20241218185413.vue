<template>
  <div class="login-container">
    <div class="wave-bg"></div>
    <h1>PayrollEmp</h1>
    
    <div class="login-form">
      <h2>Login</h2>
      <input 
        type="text" 
        v-model="username" 
        placeholder="User Name"
      >
      <input 
        type="password" 
        v-model="password" 
        placeholder="Password"
      >
      <button 
        class="sign-in" 
        @click="handleLogin"
      >
        Sign In
      </button>
      
      <div class="divider">
        <span>Or</span>
      </div>
      
      <div class="social-login">
        <button class="google" @click="handleGoogleLogin">
          <img src="../assets/google-icon.png" alt="Google">
        </button>
        <button class="facebook" @click="handleFacebookLogin">
          <img src="../assets/facebook-icon.png" alt="Facebook">

        </button>
      </div>
      
      <p class="signup-link">
        Don't have an account? <router-link :"to={name: 'signup'}>Create</router-link>
      </p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LoginPage',
  data() {
    return {
      username: '',
      password: ''
    }
  },
  methods: {
    handleLogin() {
      // Implement login logic here
      console.log('Login attempt with:', {
        username: this.username,
        password: this.password
      })
    },
    handleGoogleLogin() {
      // Implement Google login logic
      console.log('Google login clicked')
    },
    handleFacebookLogin() {
      // Implement Facebook login logic
      console.log('Facebook login clicked')
    },
    goToSignup() {
      // Implement navigation to signup page
      console.log('Navigate to signup')
      // this.$router.push('/signup')
    }
  }
}
</script>

<style scoped>
h2{
  color: black;
}
/* Your existing CSS remains the same */
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f5f5f5;
}

.login-container {
    position: relative;
    max-width: 400px;
    margin: 20px auto;
    padding: 20px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    overflow: hidden;
}

.wave-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 150px;
    background: linear-gradient(135deg, #6b2c91, #4a1f64);
    border-radius: 20px 20px 50% 50%;
}

h1 {
    color: white;
    position: relative;
    margin: 20px;
}

.login-form {
    padding: 20px;
    margin-top: 60px;
}

input {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-sizing: border-box;
}

.sign-in {
    width: 100%;
    padding: 12px;
    background: #4a1f64;
    color: white;
    border: none;
    border-radius: 8px;
    margin: 15px 0;
    cursor: pointer;
}

.divider {
    text-align: center;
    margin: 20px 0;
    position: relative;
    
    color: #6b2c91;
}

.divider::before,
.divider::after {
    content: "";
    position: absolute;
    top: 50%;
    width: 45%;
    height: 1px;
    background: #ddd;
    
    color: #6b2c91;
}

.divider::before { left: 0; }
.divider::after { right: 0; }

.social-login {
    display: flex;
    justify-content: center;
    gap: 20px;
}

.social-login button {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: 1px solid #ddd;
    background: white;
    cursor: pointer;
    padding: 8px;
}

.social-login img {
    width: 100%;
    height: 100%;
    object-fit: contain;
}

.signup-link {
    text-align: center;
    margin-top: 20px;
    color: #6b2c91;

}

.signup-link a {
    color: #6b2c91;
    text-decoration: none;
}


</style> 