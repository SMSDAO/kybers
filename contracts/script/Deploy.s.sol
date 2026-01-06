// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../core/AdminControl.sol";
import "../core/DynamicFeeManager.sol";
import "../core/TreasuryManager.sol";
import "../core/PriceAggregator.sol";
import "../core/SwapRouter.sol";
import "../security/MEVProtection.sol";
import "../core/CrossChainRouter.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying contracts with account:", deployer);
        console.log("Account balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy AdminControl
        AdminControl adminControl = new AdminControl(deployer);
        console.log("AdminControl deployed to:", address(adminControl));

        // 2. Deploy DynamicFeeManager
        DynamicFeeManager feeManager = new DynamicFeeManager();
        console.log("DynamicFeeManager deployed to:", address(feeManager));

        // 3. Deploy TreasuryManager
        TreasuryManager treasuryManager = new TreasuryManager();
        console.log("TreasuryManager deployed to:", address(treasuryManager));

        // 4. Deploy PriceAggregator
        PriceAggregator priceAggregator = new PriceAggregator();
        console.log("PriceAggregator deployed to:", address(priceAggregator));

        // 5. Deploy SwapRouter
        SwapRouter swapRouter = new SwapRouter(address(feeManager), address(treasuryManager), address(priceAggregator));
        console.log("SwapRouter deployed to:", address(swapRouter));

        // 6. Deploy MEVProtection
        MEVProtection mevProtection = new MEVProtection();
        console.log("MEVProtection deployed to:", address(mevProtection));

        // 7. Deploy CrossChainRouter
        CrossChainRouter crossChainRouter = new CrossChainRouter();
        console.log("CrossChainRouter deployed to:", address(crossChainRouter));

        // Save deployment addresses
        string memory deploymentInfo = string(
            abi.encodePacked(
                "AdminControl: ",
                vm.toString(address(adminControl)),
                "\n",
                "DynamicFeeManager: ",
                vm.toString(address(feeManager)),
                "\n",
                "TreasuryManager: ",
                vm.toString(address(treasuryManager)),
                "\n",
                "PriceAggregator: ",
                vm.toString(address(priceAggregator)),
                "\n",
                "SwapRouter: ",
                vm.toString(address(swapRouter)),
                "\n",
                "MEVProtection: ",
                vm.toString(address(mevProtection)),
                "\n",
                "CrossChainRouter: ",
                vm.toString(address(crossChainRouter))
            )
        );

        vm.writeFile("deployment-addresses.txt", deploymentInfo);

        vm.stopBroadcast();

        console.log("\n=== Deployment Complete ===");
        console.log("All addresses saved to deployment-addresses.txt");
    }
}
