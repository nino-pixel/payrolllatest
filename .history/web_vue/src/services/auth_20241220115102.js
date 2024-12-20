import api from '../utils/axios';

export const authService = {
    async login(credentials) {
        try {
            const response = await api.post('/auth/login', credentials);
            if (response.data.data.token) {
                localStorage.setItem('token', response.data.data.token);
                localStorage.setItem('user', JSON.stringify(response.data.data.user));
            }
            return response.data;
        } catch (error) {
            throw new Error(error.response?.data?.message || 'Login failed');
        }
    },

    async register(userData) {
        try {
            const response = await api.post('/auth/register', userData);
            if (response.data.data.token) {
                localStorage.setItem('token', response.data.data.token);
                localStorage.setItem('user', JSON.stringify(response.data.data.user));
            }
            return response.data;
        } catch (error) {
            throw new Error(error.response?.data?.message || 'Registration failed');
        }
    },

    logout() {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
    }
}