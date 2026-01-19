// Web3 Integration for Kybers DEX
// Supports MetaMask, WalletConnect, and Coinbase Wallet

class Web3Integration {
    constructor() {
        this.provider = null;
        this.signer = null;
        this.address = null;
        this.chainId = null;
        this.walletConnectProvider = null;
        this.isConnected = false;
    }

    // Initialize Web3
    async init() {
        console.log('🚀 Initializing Web3 Integration...');
        
        // Check if user previously connected
        const savedWallet = localStorage.getItem('kybers_wallet');
        if (savedWallet) {
            await this.connect(savedWallet);
        }
        
        // Listen for account changes
        if (window.ethereum) {
            window.ethereum.on('accountsChanged', (accounts) => {
                if (accounts.length === 0) {
                    this.disconnect();
                } else {
                    this.updateAccount(accounts[0]);
                }
            });
            
            window.ethereum.on('chainChanged', (chainId) => {
                window.location.reload();
            });
        }
    }

    // Connect wallet
    async connect(walletType = 'metamask') {
        try {
            switch (walletType) {
                case 'metamask':
                    await this.connectMetaMask();
                    break;
                case 'walletconnect':
                    await this.connectWalletConnect();
                    break;
                case 'coinbase':
                    await this.connectCoinbase();
                    break;
                default:
                    throw new Error('Unsupported wallet type');
            }
            
            localStorage.setItem('kybers_wallet', walletType);
            this.isConnected = true;
            this.updateUI();
            console.log('✅ Wallet connected:', this.address);
            
        } catch (error) {
            console.error('❌ Connection error:', error);
            throw error;
        }
    }

    // MetaMask connection
    async connectMetaMask() {
        if (typeof window.ethereum === 'undefined') {
            throw new Error('MetaMask is not installed');
        }
        
        const accounts = await window.ethereum.request({ 
            method: 'eth_requestAccounts' 
        });
        
        this.address = accounts[0];
        this.chainId = await window.ethereum.request({ 
            method: 'eth_chainId' 
        });
        
        // Create provider (simulated)
        this.provider = window.ethereum;
    }

    // WalletConnect connection (simulated)
    async connectWalletConnect() {
        console.log('🔗 Connecting via WalletConnect...');
        
        // In production, this would use @walletconnect/web3-provider
        // For now, we'll simulate the connection
        
        // Simulate connection
        // WARNING: This is for demonstration only!
        // The wallet address is generated using Math.random() which is cryptographically insecure.
        // Never use this to generate actual wallet addresses in production.
        // In production, use proper wallet connection libraries that handle address generation securely.
        this.address = '0x' + Array(40).fill(0).map(() => 
            Math.floor(Math.random() * 16).toString(16)
        ).join('');
        
        this.chainId = '0x1'; // Ethereum mainnet
        
        console.log('✅ WalletConnect connected (simulated)');
    }

    // Coinbase Wallet connection (simulated)
    async connectCoinbase() {
        console.log('💼 Connecting via Coinbase Wallet...');
        
        // In production, this would use @coinbase/wallet-sdk
        // For now, we'll simulate the connection
        
        if (window.ethereum && window.ethereum.isCoinbaseWallet) {
            const accounts = await window.ethereum.request({ 
                method: 'eth_requestAccounts' 
            });
            this.address = accounts[0];
        } else {
            // Simulate connection
            // WARNING: This is for demonstration only!
            // The wallet address is generated using Math.random() which is cryptographically insecure.
            // Never use this to generate actual wallet addresses in production.
            this.address = '0x' + Array(40).fill(0).map(() => 
                Math.floor(Math.random() * 16).toString(16)
            ).join('');
        }
        
        this.chainId = '0x1';
        console.log('✅ Coinbase Wallet connected');
    }

    // Disconnect wallet
    disconnect() {
        this.provider = null;
        this.signer = null;
        this.address = null;
        this.chainId = null;
        this.isConnected = false;
        
        localStorage.removeItem('kybers_wallet');
        this.updateUI();
        
        console.log('👋 Wallet disconnected');
    }

    // Update account
    updateAccount(newAddress) {
        this.address = newAddress;
        this.updateUI();
        console.log('🔄 Account updated:', newAddress);
    }

    // Update UI elements
    updateUI() {
        const walletAddress = document.getElementById('walletAddress');
        const walletBalance = document.getElementById('walletBalance');
        const connectWalletBtn = document.getElementById('connectWalletBtn') || 
                                 document.getElementById('connectWallet');
        
        if (this.isConnected && this.address) {
            const shortAddress = `${this.address.slice(0, 6)}...${this.address.slice(-4)}`;
            
            if (walletAddress) {
                walletAddress.textContent = shortAddress;
            }
            
            if (connectWalletBtn) {
                connectWalletBtn.textContent = 'Connected';
                connectWalletBtn.classList.add('connected');
            }
            
            // Fetch and update balance (simulated)
            this.updateBalance();
            
        } else {
            if (walletAddress) {
                walletAddress.textContent = 'Connect Wallet';
            }
            
            if (walletBalance) {
                walletBalance.textContent = '--';
            }
            
            if (connectWalletBtn) {
                connectWalletBtn.textContent = 'Connect';
                connectWalletBtn.classList.remove('connected');
            }
        }
    }

    // Update balance (simulated)
    async updateBalance() {
        const walletBalance = document.getElementById('walletBalance');
        
        if (!this.address || !walletBalance) return;
        
        // Simulate fetching balance
        const balance = (Math.random() * 10).toFixed(4);
        walletBalance.textContent = `${balance} ETH`;
    }

    // Get balance
    async getBalance(address = this.address) {
        if (!address) return '0';
        
        // Simulate balance fetch
        return (Math.random() * 100).toFixed(2);
    }

    // Get token balance
    async getTokenBalance(tokenAddress, userAddress = this.address) {
        if (!userAddress) return '0';
        
        // Simulate token balance fetch
        return (Math.random() * 1000).toFixed(2);
    }

    // Execute swap (simulated)
    async executeSwap(fromToken, toToken, amount) {
        if (!this.isConnected) {
            throw new Error('Wallet not connected');
        }
        
        console.log('🔄 Executing swap:', { fromToken, toToken, amount });
        
        // Simulate transaction
        // WARNING: This is for demonstration/testing only! 
        // The transaction hash is generated using Math.random() which is cryptographically insecure.
        // Never use this approach in production environments where actual blockchain transactions are executed.
        // In production, use a proper Web3 provider to execute real transactions.
        return new Promise((resolve) => {
            setTimeout(() => {
                const txHash = '0x' + Array(64).fill(0).map(() => 
                    Math.floor(Math.random() * 16).toString(16)
                ).join('');
                
                resolve({
                    hash: txHash,
                    status: 'success'
                });
            }, 2000);
        });
    }

    // Add liquidity (simulated)
    async addLiquidity(tokenA, tokenB, amountA, amountB) {
        if (!this.isConnected) {
            throw new Error('Wallet not connected');
        }
        
        console.log('💧 Adding liquidity:', { tokenA, tokenB, amountA, amountB });
        
        // Simulate transaction
        return new Promise((resolve) => {
            setTimeout(() => {
                const txHash = '0x' + Array(64).fill(0).map(() => 
                    Math.floor(Math.random() * 16).toString(16)
                ).join('');
                
                resolve({
                    hash: txHash,
                    lpTokens: (Math.random() * 100).toFixed(4),
                    status: 'success'
                });
            }, 2000);
        });
    }

    // Remove liquidity (simulated)
    async removeLiquidity(lpTokenAmount) {
        if (!this.isConnected) {
            throw new Error('Wallet not connected');
        }
        
        console.log('💧 Removing liquidity:', lpTokenAmount);
        
        // Simulate transaction
        return new Promise((resolve) => {
            setTimeout(() => {
                const txHash = '0x' + Array(64).fill(0).map(() => 
                    Math.floor(Math.random() * 16).toString(16)
                ).join('');
                
                resolve({
                    hash: txHash,
                    status: 'success'
                });
            }, 2000);
        });
    }

    // Switch network
    async switchNetwork(chainId) {
        if (!window.ethereum) {
            throw new Error('No Web3 provider found');
        }
        
        try {
            await window.ethereum.request({
                method: 'wallet_switchEthereumChain',
                params: [{ chainId }],
            });
        } catch (error) {
            console.error('❌ Failed to switch network:', error);
            throw error;
        }
    }

    // Format address
    formatAddress(address) {
        if (!address) return '';
        return `${address.slice(0, 6)}...${address.slice(-4)}`;
    }

    // Format amount
    formatAmount(amount, decimals = 18) {
        return (amount / Math.pow(10, decimals)).toFixed(4);
    }
}

// Create global instance
const web3Integration = new Web3Integration();

// Initialize on page load
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        web3Integration.init();
    });
} else {
    web3Integration.init();
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = Web3Integration;
}
