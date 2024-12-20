<template>
  <div class="login-container">
    <div class="wave-bg"></div>
    <h1>Payroll Admin</h1>
    
    <div class="login-form">
      <h2>Login</h2>
      <form @submit.prevent="handleLogin">
        <input 
          type="email" 
          v-model="formData.email" 
          placeholder="Email"
          required
          :disabled="loading"
        >
        <input 
          type="password" 
          v-model="formData.password" 
          placeholder="Password"
          required
          :disabled="loading"
        >
        
        <div v-if="error" class="error-message">
          {{ error }}
        </div>

        <button 
          type="submit" 
          class="sign-in"
          :disabled="loading || !isFormValid"
        >
          <span v-if="loading" class="loading-spinner"></span>
          {{ loading ? 'Signing in...' : 'Sign In' }}
        </button>
      </form>
      
      <div class="divider">
        <span>Or</span>
      </div>
      
      <div class="social-login">
        <button 
          class="google" 
          @click="handleGoogleLogin" 
          :disabled="loading"
          title="Sign in with Google"
        >
          <img src="../assets/google-icon.png" alt="Google">
        </button>
        <button 
          class="facebook" 
          @click="handleFacebookLogin" 
          :disabled="loading"
          title="Sign in with Facebook"
        >
          <img src="../assets/facebook-icon.png" alt="Facebook">
        </button>
      </div>
      
      <p class="signup-link">
        Don't have an account?
        <router-link :to="{ path: '/signup' }">Create</router-link>
      </p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'LoginPage',
  data() {
    return {
      formData: {
        email: '',
        password: ''
      },
      error: '',
      loading: false
    }
  },
  computed: {
    isFormValid() {
      return this.formData.email && this.formData.password;
    }
  },
  methods: {
    async handleLogin() {
      if (!this.isFormValid) return;

      try {
        this.loading = true;
        this.error = '';
        
        // First get CSRF cookie
        await axios.get('/sanctum/csrf-cookie');
        
        // Then attempt login
        const response = await axios.post('/api/auth/login', this.formData);
        
        if (response.data.token) {
          // Store the token
          localStorage.setItem('token', response.data.token);
          
          // Set the Authorization header for future requests
          axios.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`;
          
          // Redirect to dashboard
          this.$router.push('/dashboard');
        } else {
          this.error = 'Invalid login response';
        }
      } catch (error) {
        this.error = error.response?.data?.message || 'Login failed';
        this.formData.password = '';
        
        if (error.response?.status === 401) {
          this.formData.email = '';
          this.formData.password = '';
        }
        
        console.error('Login error:', error);
      } finally {
        this.loading = false;
      }
    },

    async handleGoogleLogin() {
      try {
        this.loading = true;
        this.error = '';
        // Implement Google OAuth logic here
        console.log('Google login clicked');
      } catch (error) {
        this.error = 'Google login failed';
        console.error('Google login error:', error);
      } finally {
        this.loading = false;
      }
    },

    async handleFacebookLogin() {
      try {
        this.loading = true;
        this.error = '';
        // Implement Facebook OAuth logic here
        console.log('Facebook login clicked');
      } catch (error) {
        this.error = 'Facebook login failed';
        console.error('Facebook login error:', error);
      } finally {
        this.loading = false;
      }
    }
  },
  beforeUnmount() {
    this.error = '';
  }
}
</script>

<style scoped>
.login-container {
  width: 100%;
  position: relative;
  min-height: 100vh;
  margin: 20px auto;
  padding: 20px;
  background: white;
  border-radius: 20px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
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
  width: 100%;
  max-width: 400px;
}

input {
  width: 100%;
  padding: 12px;
  margin: 10px 0;
  border: 1px solid #ddd;
  border-radius: 8px;
  box-sizing: border-box;
  transition: border-color 0.3s ease;
}

input:focus {
  outline: none;
  border-color: #6b2c91;
  box-shadow: 0 0 0 2px rgba(107, 44, 145, 0.1);
}

input:disabled {
  background-color: #f5f5f5;
  cursor: not-allowed;
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
  transition: background-color 0.3s ease;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
}

.sign-in:hover:not(:disabled) {
  background: #5a2574;
}

.sign-in:disabled {
  background: #9c9c9c;
  cursor: not-allowed;
}

.loading-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid #ffffff;
  border-top: 2px solid transparent;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-message {
  background-color: rgba(220, 53, 69, 0.1);
  color: #dc3545;
  padding: 10px;
  border-radius: 8px;
  margin: 10px 0;
  text-align: center;
  font-size: 0.9rem;
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
  transition: transform 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.social-login button:hover:not(:disabled) {
  transform: scale(1.1);
}

.social-login button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.social-login img {
  width: 20px;
  height: 20px;
}

.signup-link {
  text-align: center;
  margin-top: 20px;
  color: #666;
}

.signup-link a {
  color: #6b2c91;
  text-decoration: none;
  font-weight: bold;
}

.signup-link a:hover {
  text-decoration: underline;
}
</style>