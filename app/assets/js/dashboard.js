// Dashboard Page JavaScript

document.addEventListener('DOMContentLoaded', () => {
    initializeDashboard();
});

async function initializeDashboard() {
    console.log('📊 Initializing Dashboard...');
    
    setupWalletConnection();
    initializeChart();
    loadPortfolioData();
    loadAssets();
    loadTransactions();
    loadMarketData();
    
    // Refresh data every 30 seconds
    setInterval(() => {
        if (web3Integration.isConnected) {
            loadPortfolioData();
            loadAssets();
        }
        loadMarketData();
    }, 30000);
}

// Wallet Connection
function setupWalletConnection() {
    const connectBtn = document.getElementById('connectWalletBtn');
    
    if (connectBtn) {
        connectBtn.addEventListener('click', async () => {
            if (web3Integration.isConnected) {
                // Show account options
                showAccountMenu();
            } else {
                // Show wallet options
                showWalletModal();
            }
        });
    }
}

function showWalletModal() {
    // Create modal dynamically
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.style.display = 'block';
    modal.innerHTML = `
        <div class="modal-content">
            <span class="modal-close">&times;</span>
            <h2>Connect Wallet</h2>
            <div class="wallet-options">
                <button class="wallet-option" data-wallet="metamask">
                    <span class="wallet-icon">🦊</span>
                    <span class="wallet-name">MetaMask</span>
                </button>
                <button class="wallet-option" data-wallet="walletconnect">
                    <span class="wallet-icon">🔗</span>
                    <span class="wallet-name">WalletConnect</span>
                </button>
                <button class="wallet-option" data-wallet="coinbase">
                    <span class="wallet-icon">💼</span>
                    <span class="wallet-name">Coinbase Wallet</span>
                </button>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    // Event listeners
    modal.querySelector('.modal-close').addEventListener('click', () => modal.remove());
    modal.addEventListener('click', (e) => {
        if (e.target === modal) modal.remove();
    });
    
    modal.querySelectorAll('.wallet-option').forEach(option => {
        option.addEventListener('click', async () => {
            const walletType = option.dataset.wallet;
            try {
                await web3Integration.connect(walletType);
                modal.remove();
                loadPortfolioData();
                loadAssets();
            } catch (error) {
                console.error('Connection error:', error);
                alert(error.message);
            }
        });
    });
}

function showAccountMenu() {
    console.log('Showing account menu...');
    // Could show disconnect option, etc.
}

// Initialize Chart
function initializeChart() {
    const canvas = document.getElementById('portfolioChart');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    
    // Simple line chart simulation
    drawChart(ctx, canvas.width, canvas.height);
    
    // Timeframe buttons
    document.querySelectorAll('.timeframe-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            document.querySelectorAll('.timeframe-btn').forEach(b => b.classList.remove('active'));
            e.target.classList.add('active');
            drawChart(ctx, canvas.width, canvas.height);
        });
    });
}

function drawChart(ctx, width, height) {
    // Clear canvas
    ctx.clearRect(0, 0, width, height);
    
    // Generate sample data
    const dataPoints = 30;
    const data = Array.from({ length: dataPoints }, (_, i) => {
        return Math.sin(i / 5) * 50 + 150 + Math.random() * 20;
    });
    
    const maxValue = Math.max(...data);
    const minValue = Math.min(...data);
    const range = maxValue - minValue;
    
    // Draw line
    ctx.strokeStyle = '#6366F1';
    ctx.lineWidth = 2;
    ctx.beginPath();
    
    data.forEach((value, i) => {
        const x = (i / (dataPoints - 1)) * width;
        const y = height - ((value - minValue) / range) * height;
        
        if (i === 0) {
            ctx.moveTo(x, y);
        } else {
            ctx.lineTo(x, y);
        }
    });
    
    ctx.stroke();
    
    // Fill area under curve
    ctx.lineTo(width, height);
    ctx.lineTo(0, height);
    ctx.closePath();
    
    const gradient = ctx.createLinearGradient(0, 0, 0, height);
    gradient.addColorStop(0, 'rgba(99, 102, 241, 0.3)');
    gradient.addColorStop(1, 'rgba(99, 102, 241, 0)');
    ctx.fillStyle = gradient;
    ctx.fill();
}

// Load Portfolio Data
async function loadPortfolioData() {
    if (!web3Integration.isConnected) return;
    
    const balance = await web3Integration.getBalance();
    
    // Update overview cards
    document.getElementById('totalBalance').textContent = `$${(balance * 2500).toFixed(2)}`;
    document.getElementById('totalBalanceEth').textContent = `${balance} ETH`;
    document.getElementById('dailyVolume').textContent = `$${(Math.random() * 10000).toFixed(2)}`;
    document.getElementById('totalTrades').textContent = Math.floor(Math.random() * 100);
    document.getElementById('pnlValue').textContent = `$${(Math.random() * 1000).toFixed(2)}`;
}

// Load Assets
async function loadAssets() {
    const tbody = document.getElementById('assetsTableBody');
    if (!tbody) return;
    
    if (!web3Integration.isConnected) {
        tbody.innerHTML = `
            <tr class="empty-state">
                <td colspan="6">
                    <div class="empty-message">
                        <p>Connect your wallet to view assets</p>
                    </div>
                </td>
            </tr>
        `;
        return;
    }
    
    // Simulate loading assets
    const assets = [
        { symbol: 'ETH', name: 'Ethereum', balance: '2.5', value: '6250', price: '2500', change: '+5.2%' },
        { symbol: 'USDT', name: 'Tether', balance: '1000', value: '1000', price: '1.00', change: '+0.0%' },
        { symbol: 'MATIC', name: 'Polygon', balance: '500', value: '425', price: '0.85', change: '-2.3%' }
    ];
    
    tbody.innerHTML = assets.map(asset => `
        <tr>
            <td>
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    <strong>${asset.symbol}</strong>
                    <span style="color: var(--text-muted);">${asset.name}</span>
                </div>
            </td>
            <td>${asset.balance}</td>
            <td>$${asset.value}</td>
            <td>$${asset.price}</td>
            <td class="${asset.change.startsWith('+') ? 'card-change positive' : 'card-change negative'}">${asset.change}</td>
            <td>
                <button class="btn-secondary btn-small">Trade</button>
            </td>
        </tr>
    `).join('');
}

// Load Transactions
async function loadTransactions() {
    const list = document.getElementById('transactionsList');
    if (!list) return;
    
    if (!web3Integration.isConnected) {
        list.innerHTML = '<div class="empty-state"><p>No recent transactions</p></div>';
        return;
    }
    
    // Simulate transactions
    const transactions = [
        { type: 'Swap', tokens: 'ETH → USDT', amount: '0.5 ETH', time: '2 mins ago', status: 'success' },
        { type: 'Add Liquidity', tokens: 'ETH/USDT', amount: '1.0 ETH', time: '1 hour ago', status: 'success' }
    ];
    
    list.innerHTML = transactions.map(tx => `
        <div class="transaction-item" style="padding: 1rem; border-bottom: 1px solid var(--border);">
            <div style="display: flex; justify-content: space-between;">
                <div>
                    <strong>${tx.type}</strong>
                    <div style="color: var(--text-muted); font-size: 0.9rem;">${tx.tokens}</div>
                </div>
                <div style="text-align: right;">
                    <div>${tx.amount}</div>
                    <div style="color: var(--text-muted); font-size: 0.9rem;">${tx.time}</div>
                </div>
            </div>
        </div>
    `).join('');
}

// Load Market Data
async function loadMarketData() {
    // Update market stats
    document.getElementById('ethPrice').textContent = `$${(2500 + Math.random() * 100 - 50).toFixed(2)}`;
    document.getElementById('gasPrice').textContent = `${Math.floor(20 + Math.random() * 30)} gwei`;
    document.getElementById('tvlValue').textContent = `$${(75 + Math.random() * 10).toFixed(1)}M`;
}

// Refresh button
const refreshBtn = document.getElementById('refreshAssets');
if (refreshBtn) {
    refreshBtn.addEventListener('click', () => {
        loadAssets();
        showNotification('Assets refreshed', 'success');
    });
}

// Notification helper
function showNotification(message, type = 'info') {
    console.log(`[${type}] ${message}`);
    // Could implement toast notification here
}
