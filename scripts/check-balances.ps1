# Load .env manually
Get-Content ".env" | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Item -Path "env:$($matches[1])" -Value $matches[2]
    }
}

function Check-Balance {
    param(
        [string]$Name,
        [string]$Rpc,
        [string]$Symbol
    )

    # Derive deployer address from private key
    if (-not $env:DEPLOYER_ADDRESS) {
        $env:DEPLOYER_ADDRESS = cast wallet address --private-key $env:PRIVATE_KEY
    }
    
    $balanceWei = cast balance $env:DEPLOYER_ADDRESS --rpc-url $Rpc
    $balanceEth = cast from-wei $balanceWei

    Write-Host "${Name}: ${balanceEth} ${Symbol}"
}

Write-Host "----------------------------------------"
Write-Host "TESTNET BALANCES"
Write-Host "----------------------------------------"

Check-Balance "Base Sepolia" $env:BASE_TESTNET_RPC "ETH"
Check-Balance "Zora Sepolia" $env:ZORA_TESTNET_RPC "ETH"
Check-Balance "Polygon Testnet" $env:POLYGON_TESTNET_RPC "MATIC"

Write-Host "----------------------------------------"
Write-Host "MAINNET BALANCES"
Write-Host "----------------------------------------"

Check-Balance "Base Mainnet" $env:BASE_RPC_URL "ETH"
Check-Balance "Zora Mainnet" $env:ZORA_RPC_URL "ETH"
Check-Balance "Polygon Mainnet" $env:POLYGON_RPC_URL "MATIC"
