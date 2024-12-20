import axios from 'axios'

// Configure axios defaults
axios.defaults.baseURL = 'http://localhost:8000'
axios.defaults.headers.common['Accept'] = 'application/json'
axios.defaults.withCredentials = true

export const authService = {
  async register(userData) {
    try {
      const response = await axios.post('/api/auth/register', userData)
      
       // Validate name
    const nameRegex = /^[a-zA-Z\s'-]+$/
    if (!nameRegex.test(userData.name)) {
      throw new Error('Name can only contain letters, spaces, hyphens, and apostrophes')
    }
    if (userData.name.length < 2) {
      throw new Error('Name must be at least 2 characters long')
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(userData.email)) {
      throw new Error('Please enter a valid email address')
    }

    // Validate password strength
    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/
    if (!passwordRegex.test(userData.password)) {
      throw new Error('Password must be at least 8 characters long and contain letters, numbers, and special characters')
    }

    // Check password confirmation
    if (userData.password !== userData.password_confirmation) {
      throw new Error('Passwords do not match')
    }
    
      if (response.data.status === 'success') {
        // Store token and user data
        localStorage.setItem('token', response.data.data.token)
        localStorage.setItem('user', JSON.stringify(response.data.data.user))
        
        // Set the token for future requests
        axios.defaults.headers.common['Authorization'] = `Bearer ${response.data.data.token}`
        
        return {
          success: true,
          data: response.data.data
        }
      }
      
      return {
        success: false,
        error: response.data.message
      }
    } catch (error) {
      console.error('Registration error:', error.response?.data || error.message)
      throw new Error(error.response?.data?.message || 'Registration failed')
    }
  },

  async login(credentials) {
    try {
      const response = await axios.post('/api/auth/login', credentials)
      
      if (response.data.status === 'success') {
        localStorage.setItem('token', response.data.data.token)
        localStorage.setItem('user', JSON.stringify(response.data.data.user))
        axios.defaults.headers.common['Authorization'] = `Bearer ${response.data.data.token}`
        return {
          success: true,
          data: response.data.data
        }
      }
      
      return {
        success: false,
        error: response.data.message
      }
    } catch (error) {
      if (error.response?.status === 401) {
        throw new Error('Incorrect email or password')
      }
      throw new Error(error.response?.data?.message || 'Login failed')
    }
  },

  logout() {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    delete axios.defaults.headers.common['Authorization']
  }
}