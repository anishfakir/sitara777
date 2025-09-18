// api.js
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';

// Helper function to get auth headers
const getAuthHeaders = () => {
  const token = localStorage.getItem('token');
  return {
    'Content-Type': 'application/json',
    ...(token && { 'Authorization': `Bearer ${token}` })
  };
};

// Auth API
export const authAPI = {
  login: async (email, password) => {
    const response = await fetch(`${API_BASE_URL}/api/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ email, password }),
    });
    return response.json();
  },
  
  logout: async () => {
    const response = await fetch(`${API_BASE_URL}/api/auth/logout`, {
      method: 'POST',
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  getProfile: async () => {
    const response = await fetch(`${API_BASE_URL}/api/auth/me`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  }
};

// Users API
export const usersAPI = {
  getAll: async () => {
    const response = await fetch(`${API_BASE_URL}/api/users`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  getById: async (id) => {
    const response = await fetch(`${API_BASE_URL}/api/users/${id}`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  update: async (id, userData) => {
    const response = await fetch(`${API_BASE_URL}/api/users/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(userData),
    });
    return response.json();
  },
  
  delete: async (id) => {
    const response = await fetch(`${API_BASE_URL}/api/users/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders(),
    });
    return response.json();
  }
};

// Games API
export const gamesAPI = {
  getAll: async () => {
    const response = await fetch(`${API_BASE_URL}/api/games`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  create: async (gameData) => {
    const response = await fetch(`${API_BASE_URL}/api/games`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(gameData),
    });
    return response.json();
  },
  
  update: async (id, gameData) => {
    const response = await fetch(`${API_BASE_URL}/api/games/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(gameData),
    });
    return response.json();
  },
  
  delete: async (id) => {
    const response = await fetch(`${API_BASE_URL}/api/games/${id}`, {
      method: 'DELETE',
      headers: getAuthHeaders(),
    });
    return response.json();
  }
};

// Bets API
export const betsAPI = {
  getAll: async () => {
    const response = await fetch(`${API_BASE_URL}/api/bets`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  getById: async (id) => {
    const response = await fetch(`${API_BASE_URL}/api/bets/${id}`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  update: async (id, betData) => {
    const response = await fetch(`${API_BASE_URL}/api/bets/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(betData),
    });
    return response.json();
  }
};

// Results API
export const resultsAPI = {
  getAll: async () => {
    const response = await fetch(`${API_BASE_URL}/api/results`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  create: async (resultData) => {
    const response = await fetch(`${API_BASE_URL}/api/results`, {
      method: 'POST',
      headers: getAuthHeaders(),
      body: JSON.stringify(resultData),
    });
    return response.json();
  },
  
  update: async (id, resultData) => {
    const response = await fetch(`${API_BASE_URL}/api/results/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(resultData),
    });
    return response.json();
  }
};

// Transactions API
export const transactionsAPI = {
  getAll: async () => {
    const response = await fetch(`${API_BASE_URL}/api/transactions`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  update: async (id, transactionData) => {
    const response = await fetch(`${API_BASE_URL}/api/transactions/${id}`, {
      method: 'PUT',
      headers: getAuthHeaders(),
      body: JSON.stringify(transactionData),
    });
    return response.json();
  }
};

// Dashboard API
export const dashboardAPI = {
  getStats: async () => {
    const response = await fetch(`${API_BASE_URL}/api/dashboard/stats`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  },
  
  getCharts: async () => {
    const response = await fetch(`${API_BASE_URL}/api/dashboard/charts`, {
      headers: getAuthHeaders(),
    });
    return response.json();
  }
};