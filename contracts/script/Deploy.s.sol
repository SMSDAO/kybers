// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";

// Core system contracts
import "../admin/AdminControl.sol";
import "../core/TreasuryManager.sol";
import "../core/SwapRouter.sol";
import "../core/DynamicFeeManager.sol";
import "../core/PriceAggregator.sol";

contract Deploy is Script {
    // Environment variables
    address payable deployer;
    address payable treasury;
    address priceFeed;
    address weth;
    address usdc;

    function setUp() public {
        deployer = payable(vm.envAddress("DEPLOYER"));
        treasury = payable(vm.envAddress("TREASURY"));
        priceFeed = vm.envAddress("PRICE_FEED");
        weth = vm.envAddress("WETH");
        usdc = vm.envAddress("USDC");
    }

    function run() public {
        vm.startBroadcast();

        // 1. AdminControl
        AdminControl admin = new AdminControl(deployer);

        // 2. TreasuryManager
        TreasuryManager treasuryManager = new TreasuryManager(treasury);

        // 3. PriceAggregator
        PriceAggregator aggregator = new PriceAggregator();

        // 4. DynamicFeeManager
        DynamicFeeManager feeManager = new DynamicFeeManager();

        // 5. SwapRouter
        SwapRouter router = new SwapRouter(
            address(feeManager),
            payable(address(treasuryManager)),
            address(aggregator)
        );

        // 6. Role assignments
        admin.grantRole(admin.OPERATOR_ROLE(), address(treasuryManager));
        admin.grantRole(admin.OPERATOR_ROLE(), address(router));
        admin.grantRole(admin.OPERATOR_ROLE(), address(feeManager));

        vm.stopBroadcast();

        // 7. Emit addresses for verify-deployment.sh
        console2.log("ADMIN_CONTROL", address(admin));
        console2.log("TREASURY_MANAGER", address(treasuryManager));
        console2.log("PRICE_AGGREGATOR", address(aggregator));
        console2.log("FEE_MANAGER", address(feeManager));
        console2.log("SWAP_ROUTER", address(router));
    }
}
