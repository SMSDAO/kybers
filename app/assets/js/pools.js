// Pools Page JavaScript

document.addEventListener('DOMContentLoaded', () => {
    initializePools();
});

let selectedTokenA = { symbol: 'ETH', address: '0x0' };
let selectedTokenB = { symbol: 'USDT', address: '0x1' };

async function initializePools() {
    console.log('💧 Initializing Pools...');
    
    setupTabs();
    setupLiquidityInputs();
    setupTokenSelectors();
    loadPoolsData();
    
    if (web3Integration.isConnected) {
        updateBalances();
        loadUserPositions();
    }
}

// Setup Tabs
function setupTabs() {
    const tabBtns = document.querySelectorAll('.tab-btn');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const tabName = btn.dataset.tab;
            
            // Update active states
            tabBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            // Show corresponding content
            tabContents.forEach(content => {
                if (content.id === `${tabName}LiquidityTab` || content.id === `${tabName}PoolsTab`) {
                    content.classList.add('active');
                } else {
                    content.classList.remove('active');
                }
            });
        });
    });
}

// Setup Liquidity Inputs
function setupLiquidityInputs() {
    const tokenAInput = document.getElementById('tokenAAmount');
    const tokenBInput = document.getElementById('tokenBAmount');
    
    if (tokenAInput) {
        tokenAInput.addEventListener('input', (e) => {
            const amount = parseFloat(e.target.value) || 0;
            calculateTokenBAmount(amount);
            updatePoolDetails(amount);
        });
    }
    
    if (tokenBInput) {
        tokenBInput.addEventListener('input', (e) => {
            const amount = parseFloat(e.target.value) || 0;
            calculateTokenAAmount(amount);
        });
    }
}

// Calculate Token B Amount
function calculateTokenBAmount(tokenAAmount) {
    const tokenBInput = document.getElementById('tokenBAmount');
    if (!tokenBInput) return;
    
    // Simulate price ratio (e.g., 1 ETH = 2500 USDT)
    const ratio = 2500;
    const tokenBAmount = tokenAAmount * ratio;
    
    tokenBInput.value = tokenBAmount.toFixed(2);
}

// Calculate Token A Amount
function calculateTokenAAmount(tokenBAmount) {
    const tokenAInput = document.getElementById('tokenAAmount');
    if (!tokenAInput) return;
    
    const ratio = 2500;
    const tokenAAmount = tokenBAmount / ratio;
    
    tokenAInput.value = tokenAAmount.toFixed(6);
}

// Update Pool Details
function updatePoolDetails(tokenAAmount) {
    if (tokenAAmount <= 0) return;
    
    // Simulate pool calculations
    const poolShare = (Math.random() * 0.5).toFixed(4);
    const apr = (Math.random() * 20 + 5).toFixed(2);
    const lpTokens = (tokenAAmount * Math.random() * 100).toFixed(4);
    
    document.getElementById('poolShare').textContent = `${poolShare}%`;
    document.getElementById('currentApr').textContent = `${apr}%`;
    document.getElementById('lpTokens').textContent = lpTokens;
}

// Setup Token Selectors
function setupTokenSelectors() {
    const tokenASelect = document.getElementById('tokenASelect');
    const tokenBSelect = document.getElementById('tokenBSelect');
    
    if (tokenASelect) {
        tokenASelect.addEventListener('click', () => {
            showTokenModal('A');
        });
    }
    
    if (tokenBSelect) {
        tokenBSelect.addEventListener('click', () => {
            showTokenModal('B');
        });
    }
}

// Show Token Modal (reuse from swap)
function showTokenModal(type) {
    // Similar to swap token modal
    console.log(`Selecting token ${type}`);
}

// Update Balances
async function updateBalances() {
    if (!web3Integration.isConnected) return;
    
    const balanceA = await web3Integration.getTokenBalance(selectedTokenA.address);
    const balanceB = await web3Integration.getTokenBalance(selectedTokenB.address);
    
    document.getElementById('tokenABalance').textContent = `Balance: ${balanceA}`;
    document.getElementById('tokenBBalance').textContent = `Balance: ${balanceB}`;
}

// Add Liquidity Button
const addLiquidityBtn = document.getElementById('addLiquidityBtn');
if (addLiquidityBtn) {
    addLiquidityBtn.addEventListener('click', async () => {
        if (!web3Integration.isConnected) {
            alert('Please connect your wallet');
            return;
        }
        
        const amountA = parseFloat(document.getElementById('tokenAAmount').value);
        const amountB = parseFloat(document.getElementById('tokenBAmount').value);
        
        if (!amountA || !amountB) {
            alert('Please enter amounts for both tokens');
            return;
        }
        
        await addLiquidity(amountA, amountB);
    });
}

// Add Liquidity
async function addLiquidity(amountA, amountB) {
    addLiquidityBtn.textContent = 'Adding Liquidity...';
    addLiquidityBtn.disabled = true;
    
    try {
        const result = await web3Integration.addLiquidity(
            selectedTokenA.address,
            selectedTokenB.address,
            amountA,
            amountB
        );
        
        console.log('Add liquidity result:', result);
        
        addLiquidityBtn.textContent = 'Success!';
        
        setTimeout(() => {
            addLiquidityBtn.textContent = 'Add Liquidity';
            addLiquidityBtn.disabled = false;
            
            // Clear inputs
            document.getElementById('tokenAAmount').value = '';
            document.getElementById('tokenBAmount').value = '';
            
            // Reload positions
            loadUserPositions();
        }, 2000);
        
    } catch (error) {
        console.error('Add liquidity error:', error);
        addLiquidityBtn.textContent = 'Failed';
        
        setTimeout(() => {
            addLiquidityBtn.textContent = 'Add Liquidity';
            addLiquidityBtn.disabled = false;
        }, 2000);
    }
}

// Load Pools Data
function loadPoolsData() {
    // Update overview stats
    document.getElementById('totalTvl').textContent = `$${(Math.random() * 100 + 50).toFixed(1)}M`;
    document.getElementById('totalVolume').textContent = `$${(Math.random() * 10 + 5).toFixed(1)}M`;
    
    if (web3Integration.isConnected) {
        document.getElementById('myLiquidity').textContent = `$${(Math.random() * 10000).toFixed(2)}`;
        document.getElementById('feesEarned').textContent = `$${(Math.random() * 100).toFixed(2)}`;
    }
}

// Load User Positions
async function loadUserPositions() {
    const positionsDiv = document.getElementById('liquidityPositions');
    if (!positionsDiv) return;
    
    if (!web3Integration.isConnected) {
        positionsDiv.innerHTML = '<div class="empty-state"><p>No liquidity positions</p></div>';
        return;
    }
    
    // Simulate user positions
    const positions = [
        { pair: 'ETH/USDT', liquidity: '5000', share: '0.25', apr: '12.5' },
        { pair: 'ETH/USDC', liquidity: '3000', share: '0.15', apr: '10.2' }
    ];
    
    positionsDiv.innerHTML = positions.map(pos => `
        <div class="position-card" style="
            background: var(--surface);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 1rem;
        ">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <strong>${pos.pair}</strong>
                <span class="apr-badge">${pos.apr}% APR</span>
            </div>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                <div>
                    <div style="color: var(--text-muted); font-size: 0.9rem;">Liquidity</div>
                    <div style="font-weight: 600;">$${pos.liquidity}</div>
                </div>
                <div>
                    <div style="color: var(--text-muted); font-size: 0.9rem;">Pool Share</div>
                    <div style="font-weight: 600;">${pos.share}%</div>
                </div>
            </div>
            <button class="btn-secondary" style="width: 100%;" onclick="removePosition('${pos.pair}')">
                Remove Liquidity
            </button>
        </div>
    `).join('');
}

// Remove Position
async function removePosition(pair) {
    if (confirm(`Remove liquidity from ${pair}?`)) {
        try {
            await web3Integration.removeLiquidity(100);
            console.log('Liquidity removed');
            loadUserPositions();
        } catch (error) {
            console.error('Remove liquidity error:', error);
        }
    }
}

// Claim Rewards
const claimRewardsBtn = document.getElementById('claimRewards');
if (claimRewardsBtn) {
    claimRewardsBtn.addEventListener('click', async () => {
        if (!web3Integration.isConnected) {
            alert('Please connect your wallet');
            return;
        }
        
        claimRewardsBtn.textContent = 'Claiming...';
        claimRewardsBtn.disabled = true;
        
        setTimeout(() => {
            claimRewardsBtn.textContent = 'Claimed!';
            document.getElementById('pendingRewards').textContent = '0 KYBER';
            
            setTimeout(() => {
                claimRewardsBtn.textContent = 'Claim Rewards';
                claimRewardsBtn.disabled = false;
            }, 2000);
        }, 2000);
    });
}

// Refresh data periodically
setInterval(() => {
    loadPoolsData();
    if (web3Integration.isConnected) {
        loadUserPositions();
    }
}, 30000);
