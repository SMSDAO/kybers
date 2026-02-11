// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../core/DynamicFeeManager.sol";

contract DynamicFeeManagerTest is Test {
    DynamicFeeManager public feeManager;
    address public owner;
    address public user1;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        feeManager = new DynamicFeeManager();
    }

    function testBaseFee() public {
        assertEq(feeManager.BASE_FEE(), 5, "Base fee should be 5 basis points (0.05%)");
    }

    function testMaxFee() public {
        assertEq(feeManager.MAX_FEE(), 30, "Max fee should be 30 basis points (0.3%)");
    }

    function testCalculateFee() public view {
        uint256 amount = 1000 ether;
        uint256 liquidityDepth = 1000000 ether;

        uint256 fee = feeManager.calculateFee(user1, amount, liquidityDepth);

        // Base fee of 0.05% on 1000 ether = 0.5 ether
        assertGt(fee, 0, "Fee should be greater than 0");
        assertLt(fee, amount, "Fee should be less than amount");
    }

    function testFeeExemption() public {
        feeManager.setFeeExemption(user1, true);

        uint256 amount = 1000 ether;
        uint256 liquidityDepth = 1000000 ether;
        uint256 fee = feeManager.calculateFee(user1, amount, liquidityDepth);

        assertEq(fee, 0, "Exempted user should have 0 fee");
    }

    function testUpdateFeeConfig() public {
        uint256 congestionAdj = 2;
        uint256 volatilityAdj = 1;

        feeManager.updateFeeConfig(congestionAdj, volatilityAdj);

        (,uint256 storedCongestion, uint256 storedVolatility,,) = feeManager.feeConfig();

        assertEq(storedCongestion, congestionAdj, "Congestion adjustment not set");
        assertEq(storedVolatility, volatilityAdj, "Volatility adjustment not set");
    }

    function testMaxFeeNotExceeded() public {
        // Set adjustments that when added to BASE_FEE still stay under MAX_FEE
        // BASE_FEE = 5, so max adjustments = 25 (5 + 25 = 30 = MAX_FEE)
        feeManager.updateFeeConfig(10, 10); // Total: 5 + 10 + 10 = 25

        uint256 amount = 1000 ether;
        uint256 liquidityDepth = 100 ether;

        uint256 effectiveFeeRate = feeManager.getEffectiveFeeRate(user1, amount, liquidityDepth);

        assertLe(effectiveFeeRate, feeManager.MAX_FEE(), "Effective fee should not exceed max fee");
    }

    function testUserTierDiscount() public {
        feeManager.updateUserTier(user1, 1000000 ether);

        (uint256 volume, uint256 discount,) = feeManager.userTiers(user1);

        assertEq(volume, 1000000 ether, "Volume not recorded");
        assertEq(discount, 3, "Should have 3 basis point discount for 1M volume");
    }

    function testFuzzCalculateFee(uint256 amount) public view {
        vm.assume(amount > 0 && amount < 1000000 ether);

        uint256 liquidityDepth = 1000000 ether;
        uint256 fee = feeManager.calculateFee(user1, amount, liquidityDepth);

        // Fee should always be less than or equal to MAX_FEE percentage
        uint256 maxPossibleFee = (amount * feeManager.MAX_FEE()) / feeManager.FEE_DENOMINATOR();
        assertLe(fee, maxPossibleFee, "Fee exceeds maximum");
    }
}
