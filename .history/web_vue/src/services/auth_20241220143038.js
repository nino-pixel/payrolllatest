import axios from 'axios'

// Configure axios defaults
axios.defaults.baseURL = 'http://localhost:8000'
axios.defaults.headers.common['Accept'] = 'application/json'
axios.defaults.withCredentials = true

export const authService = {
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