const axios = require('axios');

async function checkHealth() {
  try {
    const response = await axios.get('http://localhost:4000/health', {
      timeout: 3000,
    });
    
    if (response.data.status === 'healthy') {
      process.exit(0);
    } else {
      process.exit(1);
    }
  } catch (error) {
    console.error('Health check failed:', error.message);
    process.exit(1);
  }
}

checkHealth();
