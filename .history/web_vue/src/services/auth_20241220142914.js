import axios from 'axios'

// Configure axios defaults
axios.defaults.baseURL = 'http://localhost:8000'
axios.defaults.headers.common['Accept'] = 'application/json'
axios.defaults.withCredentials = true

export const authService = {
  async register(userData) {
    try {
      const response = await axios.post('/api/auth/register', userData)
      
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
    } catch (error) {  if (error.response) {
        switch (error.response.status) {
          case 401:
            throw new Error('Incorrect email or password')
          case 422:
            const validationErrors = error.response.data.errors
            if (validationErrors.email) {
              throw new Error('Invalid email format')
            }
            if (validationErrors.password) {
              throw new Error('Password is required')
            }
            throw new Error('Validation failed')
          case 429:
            throw new Error('Too many login attempts. Please try again later.')
          default:
            throw new Error(error.response.data.message || 'Login failed')
        }
      }
    }
  },

  logout() {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    delete axios.defaults.headers.common['Authorization']
  }
}