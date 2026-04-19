// Main JavaScript for Kybers DEX Landing Page

document.addEventListener('DOMContentLoaded', () => {
    initializeApp();
});

function initializeApp() {
    console.log('🚀 Kybers DEX Initialized');
    
    // Initialize components
    initializeNavigation();
    initializeWalletModal();
    initializeStats();
    initializeAnimations();
    initializeSmoothScroll();
}

// Navigation
function initializeNavigation() {
    const navbar = document.getElementById('navbar');
    const navToggle = document.getElementById('navToggle');
    const navMenu = document.getElementById('navMenu');
    
    // Scroll effect for navbar
    let lastScroll = 0;
    window.addEventListener('scroll', () => {
        const currentScroll = window.pageYOffset;
        
        if (currentScroll > 100) {
            navbar.style.background = 'rgba(15, 23, 42, 0.95)';
            navbar.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.3)';
        } else {
            navbar.style.background = 'rgba(15, 23, 42, 0.8)';
            navbar.style.boxShadow = 'none';
        }
        
        lastScroll = currentScroll;
    });
    
    // Mobile menu toggle
    if (navToggle && navMenu) {
        navToggle.addEventListener('click', () => {
            navMenu.classList.toggle('active');
            navToggle.classList.toggle('active');
        });
    }
}

// Wallet Modal
function initializeWalletModal() {
    const modal = document.getElementById('walletModal');
    const connectWalletBtn = document.getElementById('connectWallet');
    const closeBtn = modal?.querySelector('.modal-close');
    const walletOptions = modal?.querySelectorAll('.wallet-option');
    
    // Open modal
    if (connectWalletBtn) {
        connectWalletBtn.addEventListener('click', () => {
            if (web3Integration.isConnected) {
                // Already connected, maybe show disconnect option
                console.log('Already connected');
            } else {
                modal.style.display = 'block';
            }
        });
    }
    
    // Close modal
    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });
    }
    
    // Close on outside click
    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
    
    // Wallet option selection
    walletOptions?.forEach(option => {
        option.addEventListener('click', async () => {
            const walletType = option.dataset.wallet;
            
            try {
                await web3Integration.connect(walletType);
                modal.style.display = 'none';
                showNotification('Wallet connected successfully!', 'success');
            } catch (error) {
                console.error('Connection error:', error);
                showNotification(error.message || 'Failed to connect wallet', 'error');
            }
        });
    });
}

// Dynamic Stats with async updates
function initializeStats() {
    const tvlElement = document.getElementById('tvl');
    const volumeElement = document.getElementById('volume');
    const usersElement = document.getElementById('users');
    
    // Simulate fetching real-time data
    async function updateStats() {
        // In production, this would fetch from API
        const stats = await fetchMarketStats();
        
        if (tvlElement) animateValue(tvlElement, 0, stats.tvl, 2000, '$', 'M');
        if (volumeElement) animateValue(volumeElement, 0, stats.volume, 2000, '$', 'M');
        if (usersElement) animateValue(usersElement, 0, stats.users, 2000, '', 'K');
    }
    
    updateStats();
    
    // Update every 30 seconds
    setInterval(updateStats, 30000);
}

// Fetch market stats (simulated)
async function fetchMarketStats() {
    // Simulate API call
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve({
                tvl: Math.floor(Math.random() * 100) + 50,
                volume: Math.floor(Math.random() * 50) + 10,
                users: Math.floor(Math.random() * 100) + 50
            });
        }, 500);
    });
}

// Animate number values
function animateValue(element, start, end, duration, prefix = '', suffix = '') {
    const startTime = performance.now();
    
    function update(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        // Easing function
        const easeOutQuad = progress * (2 - progress);
        const current = start + (end - start) * easeOutQuad;
        
        element.textContent = `${prefix}${Math.floor(current)}${suffix}`;
        
        if (progress < 1) {
            requestAnimationFrame(update);
        }
    }
    
    requestAnimationFrame(update);
}

// Initialize animations
function initializeAnimations() {
    // Intersection Observer for scroll animations
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animated');
            }
        });
    }, {
        threshold: 0.1
    });
    
    // Observe feature cards
    document.querySelectorAll('.feature-card').forEach(card => {
        observer.observe(card);
    });
    
    // Add hover effects to cards
    document.querySelectorAll('.feature-card').forEach((card, index) => {
        card.style.animationDelay = `${index * 0.1}s`;
    });
}

// Smooth scroll
function initializeSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (href === '#') return;
            
            e.preventDefault();
            const target = document.querySelector(href);
            
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// Button actions
const launchAppBtn = document.getElementById('launchApp');
const learnMoreBtn = document.getElementById('learnMore');
const getStartedBtn = document.getElementById('getStarted');

if (launchAppBtn) {
    launchAppBtn.addEventListener('click', () => {
        window.location.href = '/app/dashboard.html';
    });
}

if (learnMoreBtn) {
    learnMoreBtn.addEventListener('click', () => {
        document.querySelector('#about').scrollIntoView({ behavior: 'smooth' });
    });
}

if (getStartedBtn) {
    getStartedBtn.addEventListener('click', () => {
        window.location.href = '/app/dashboard.html';
    });
}

// Notification system
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    
    notification.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        padding: 1rem 1.5rem;
        background: ${type === 'success' ? '#10B981' : type === 'error' ? '#EF4444' : '#6366F1'};
        color: white;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        z-index: 9999;
        animation: slideInRight 0.3s ease-out;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOutRight 0.3s ease-out';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Async data loading for dynamic content
async function loadDynamicContent() {
    try {
        // Fetch trending pairs
        const trendingPairs = await fetchTrendingPairs();
        updateTrendingPairs(trendingPairs);
        
        // Fetch market overview
        const marketOverview = await fetchMarketOverview();
        updateMarketOverview(marketOverview);
        
    } catch (error) {
        console.error('Error loading dynamic content:', error);
    }
}

// Simulated API calls
async function fetchTrendingPairs() {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve([
                { pair: 'ETH/USDT', price: 2500, change: 5.2 },
                { pair: 'BTC/USDT', price: 45000, change: 3.1 },
                { pair: 'MATIC/USDT', price: 0.85, change: -2.3 }
            ]);
        }, 500);
    });
}

async function fetchMarketOverview() {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve({
                ethPrice: 2500,
                gasPrice: 25,
                tvl: 75
            });
        }, 500);
    });
}

function updateTrendingPairs(pairs) {
    // Update UI with trending pairs
    console.log('Trending pairs:', pairs);
}

function updateMarketOverview(overview) {
    // Update UI with market overview
    console.log('Market overview:', overview);
}

// Initialize dynamic content
loadDynamicContent();

// Refresh dynamic content every minute
setInterval(loadDynamicContent, 60000);

// Export functions for use in other scripts
window.kybersApp = {
    showNotification,
    loadDynamicContent
};
