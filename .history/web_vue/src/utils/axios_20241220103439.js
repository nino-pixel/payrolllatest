import axios from 'axios';

const api = axios.create({
    baseURL: 'http://localhost:8000/api',
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    },
    withCredentials: true
});

// Add response interceptor for error handling
api.interceptors.response.use(
    response => response,
    error => {
        if (error.response?.status === 422) {
            // Validation errors
            return Promise.reject(error.response.data);
        }
        return Promise.reject(error);
    }
);

export default api;