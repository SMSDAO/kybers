// Swap Page JavaScript

document.addEventListener('DOMContentLoaded', () => {
    initializeSwap();
});

let selectedFromToken = { symbol: 'ETH', address: '0x0' };
let selectedToToken = { symbol: 'USDT', address: '0x1' };

async function initializeSwap() {
    console.log('🔄 Initializing Swap...');
    
    setupSwapInputs();
    setupTokenSelectors();
    setupSwapButton();
    updateSwapButton();
    
    // Load initial data
    if (web3Integration.isConnected) {
        updateBalances();
    }
}

// Setup Swap Inputs
function setupSwapInputs() {
    const fromInput = document.getElementById('fromAmount');
    const toInput = document.getElementById('toAmount');
    const maxBtn = document.getElementById('maxBtn');
    const flipBtn = document.getElementById('swapFlipBtn');
    
    // From amount input
    if (fromInput) {
        fromInput.addEventListener('input', async (e) => {
            const amount = parseFloat(e.target.value) || 0;
            await calculateSwapOutput(amount);
        });
    }
    
    // Max button
    if (maxBtn) {
        maxBtn.addEventListener('click', async () => {
            const balance = await web3Integration.getBalance();
            fromInput.value = balance;
            await calculateSwapOutput(parseFloat(balance));
        });
    }
    
    // Flip button
    if (flipBtn) {
        flipBtn.addEventListener('click', () => {
            // Swap tokens
            const temp = selectedFromToken;
            selectedFromToken = selectedToToken;
            selectedToToken = temp;
            
            // Update UI
            updateTokenSelectors();
            updateBalances();
            
            // Clear inputs
            fromInput.value = '';
            toInput.value = '';
            document.getElementById('swapDetails').style.display = 'none';
        });
    }
}

// Calculate Swap Output
async function calculateSwapOutput(inputAmount) {
    const toInput = document.getElementById('toAmount');
    const swapDetails = document.getElementById('swapDetails');
    
    if (inputAmount <= 0) {
        toInput.value = '';
        swapDetails.style.display = 'none';
        return;
    }
    
    // Simulate price calculation (0.3% fee)
    const rate = 2500; // ETH/USDT example rate
    const outputAmount = inputAmount * rate * 0.997; // 0.3% fee
    
    toInput.value = outputAmount.toFixed(2);
    
    // Update swap details
    document.getElementById('swapRate').textContent = `1 ${selectedFromToken.symbol} = ${rate} ${selectedToToken.symbol}`;
    document.getElementById('priceImpact').textContent = '< 0.1%';
    document.getElementById('swapFee').textContent = '0.3%';
    document.getElementById('minReceived').textContent = `${(outputAmount * 0.995).toFixed(2)} ${selectedToToken.symbol}`;
    
    // Update USD values
    document.getElementById('fromUsdValue').textContent = `$${(inputAmount * rate).toFixed(2)}`;
    document.getElementById('toUsdValue').textContent = `$${outputAmount.toFixed(2)}`;
    
    swapDetails.style.display = 'block';
}

// Setup Token Selectors
function setupTokenSelectors() {
    const fromSelect = document.getElementById('fromTokenSelect');
    const toSelect = document.getElementById('toTokenSelect');
    
    if (fromSelect) {
        fromSelect.addEventListener('click', () => {
            showTokenModal('from');
        });
    }
    
    if (toSelect) {
        toSelect.addEventListener('click', () => {
            showTokenModal('to');
        });
    }
}

// Show Token Selection Modal
function showTokenModal(direction) {
    const modal = document.getElementById('tokenModal') || createTokenModal();
    modal.style.display = 'block';
    
    // Populate token list
    const tokenList = document.getElementById('tokenList');
    const tokens = getTokenList();
    
    tokenList.innerHTML = tokens.map(token => `
        <div class="token-list-item" data-symbol="${token.symbol}" data-address="${token.address}" style="
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            cursor: pointer;
            border-radius: 12px;
            transition: background 0.3s;
        " onmouseover="this.style.background='var(--surface)'" onmouseout="this.style.background='transparent'">
            <img src="/app/assets/images/tokens/${token.symbol.toLowerCase()}.svg" 
                 alt="${token.symbol}" 
                 style="width: 32px; height: 32px;"
                 onerror="this.style.display='none'">
            <div style="flex: 1;">
                <div style="font-weight: 600;">${token.symbol}</div>
                <div style="color: var(--text-muted); font-size: 0.9rem;">${token.name}</div>
            </div>
            <div style="text-align: right;">
                <div>${token.balance}</div>
            </div>
        </div>
    `).join('');
    
    // Add click handlers
    tokenList.querySelectorAll('.token-list-item').forEach(item => {
        item.addEventListener('click', () => {
            const symbol = item.dataset.symbol;
            const address = item.dataset.address;
            
            if (direction === 'from') {
                selectedFromToken = { symbol, address };
            } else {
                selectedToToken = { symbol, address };
            }
            
            updateTokenSelectors();
            updateBalances();
            modal.style.display = 'none';
            
            // Recalculate if there's an amount
            const fromAmount = parseFloat(document.getElementById('fromAmount').value);
            if (fromAmount > 0) {
                calculateSwapOutput(fromAmount);
            }
        });
    });
}

// Create Token Modal
function createTokenModal() {
    const modal = document.createElement('div');
    modal.id = 'tokenModal';
    modal.className = 'modal';
    modal.innerHTML = `
        <div class="modal-content">
            <span class="modal-close">&times;</span>
            <h2>Select a token</h2>
            <input type="text" class="token-search" placeholder="Search name or paste address" id="tokenSearch">
            <div class="token-list" id="tokenList" style="max-height: 400px; overflow-y: auto;"></div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    // Close handlers
    modal.querySelector('.modal-close').addEventListener('click', () => {
        modal.style.display = 'none';
    });
    
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
    
    // Search functionality
    const searchInput = modal.querySelector('#tokenSearch');
    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const items = modal.querySelectorAll('.token-list-item');
        
        items.forEach(item => {
            const symbol = item.dataset.symbol.toLowerCase();
            if (symbol.includes(query)) {
                item.style.display = 'flex';
            } else {
                item.style.display = 'none';
            }
        });
    });
    
    return modal;
}

// Get Token List
function getTokenList() {
    return [
        { symbol: 'ETH', name: 'Ethereum', address: '0x0', balance: '2.5' },
        { symbol: 'USDT', name: 'Tether USD', address: '0x1', balance: '1000.0' },
        { symbol: 'USDC', name: 'USD Coin', address: '0x2', balance: '500.0' },
        { symbol: 'DAI', name: 'Dai Stablecoin', address: '0x3', balance: '250.0' },
        { symbol: 'WBTC', name: 'Wrapped Bitcoin', address: '0x4', balance: '0.05' },
        { symbol: 'MATIC', name: 'Polygon', address: '0x5', balance: '500.0' }
    ];
}

// Update Token Selectors
function updateTokenSelectors() {
    const fromSelect = document.getElementById('fromTokenSelect');
    const toSelect = document.getElementById('toTokenSelect');
    
    if (fromSelect) {
        fromSelect.querySelector('.token-symbol').textContent = selectedFromToken.symbol;
    }
    
    if (toSelect) {
        toSelect.querySelector('.token-symbol').textContent = selectedToToken.symbol;
    }
}

// Update Balances
async function updateBalances() {
    if (!web3Integration.isConnected) {
        document.getElementById('fromBalance').textContent = 'Balance: --';
        document.getElementById('toBalance').textContent = 'Balance: --';
        return;
    }
    
    const fromBalance = await web3Integration.getTokenBalance(selectedFromToken.address);
    const toBalance = await web3Integration.getTokenBalance(selectedToToken.address);
    
    document.getElementById('fromBalance').textContent = `Balance: ${fromBalance}`;
    document.getElementById('toBalance').textContent = `Balance: ${toBalance}`;
}

// Setup Swap Button
function setupSwapButton() {
    const swapBtn = document.getElementById('swapBtn');
    
    if (swapBtn) {
        swapBtn.addEventListener('click', async () => {
            if (!web3Integration.isConnected) {
                // Show wallet connection
                window.location.href = '#';
                return;
            }
            
            const amount = parseFloat(document.getElementById('fromAmount').value);
            if (!amount || amount <= 0) {
                alert('Please enter an amount');
                return;
            }
            
            await executeSwap(amount);
        });
    }
}

// Execute Swap
async function executeSwap(amount) {
    const swapBtn = document.getElementById('swapBtn');
    const btnText = document.getElementById('swapBtnText');
    
    try {
        btnText.textContent = 'Swapping...';
        swapBtn.disabled = true;
        
        const result = await web3Integration.executeSwap(
            selectedFromToken.address,
            selectedToToken.address,
            amount
        );
        
        console.log('Swap result:', result);
        
        btnText.textContent = 'Swap Successful!';
        
        // Reset after delay
        setTimeout(() => {
            btnText.textContent = 'Swap';
            swapBtn.disabled = false;
            
            // Clear inputs
            document.getElementById('fromAmount').value = '';
            document.getElementById('toAmount').value = '';
            document.getElementById('swapDetails').style.display = 'none';
            
            // Update balances
            updateBalances();
        }, 2000);
        
    } catch (error) {
        console.error('Swap error:', error);
        btnText.textContent = 'Swap Failed';
        
        setTimeout(() => {
            btnText.textContent = 'Swap';
            swapBtn.disabled = false;
        }, 2000);
    }
}

// Update Swap Button State
function updateSwapButton() {
    const btnText = document.getElementById('swapBtnText');
    
    if (!web3Integration.isConnected) {
        btnText.textContent = 'Connect Wallet';
    } else {
        btnText.textContent = 'Swap';
    }
}

// Listen for wallet connection changes
setInterval(updateSwapButton, 1000);
