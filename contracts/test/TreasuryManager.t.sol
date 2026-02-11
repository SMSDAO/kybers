// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../core/TreasuryManager.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("Mock Token", "MOCK") {
        _mint(msg.sender, 1000000 ether);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract TreasuryManagerTest is Test {
    TreasuryManager public treasury;
    MockERC20 public token;
    address public owner;
    address public user1;
    address public authorizedCaller;
    address public constant TREASURY_ADDRESS = 0x6d8c7A3B1e0F8F0F5e3B9F6E8c7A3B1e0F8F0F5e;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        authorizedCaller = address(0x2);
        treasury = new TreasuryManager(TREASURY_ADDRESS);
        token = new MockERC20();

        // Authorize caller
        treasury.setAuthorizedCaller(authorizedCaller, true);

        // Fund user1
        token.mint(user1, 1000 ether);
        token.mint(authorizedCaller, 1000 ether);
        vm.deal(user1, 10 ether);
        vm.deal(authorizedCaller, 10 ether);
    }

    function testTreasuryAddress() public view {
        assertEq(treasury.treasuryAddress(), TREASURY_ADDRESS, "Treasury address mismatch");
    }

    function testCollectETHFee() public {
        vm.startPrank(authorizedCaller);
        
        uint256 feeAmount = 0.1 ether;
        treasury.collectFee{value: feeAmount}(address(0), feeAmount);

        (uint256 accumulated,,) = treasury.getTokenBalance(address(0));
        assertEq(accumulated, feeAmount, "ETH fee not collected");

        vm.stopPrank();
    }

    function testUnauthorizedCollectFails() public {
        vm.startPrank(user1);
        
        uint256 feeAmount = 0.1 ether;
        vm.expectRevert("Caller not authorized");
        treasury.collectFee{value: feeAmount}(address(0), feeAmount);

        vm.stopPrank();
    }

    function testCollectERC20Fee() public {
        vm.startPrank(authorizedCaller);
        
        uint256 feeAmount = 0.5 ether; // Below auto-forward threshold
        token.approve(address(treasury), feeAmount);
        treasury.collectFee(address(token), feeAmount);

        (uint256 accumulated,,) = treasury.getTokenBalance(address(token));
        assertEq(accumulated, feeAmount, "Token fee not collected");

        vm.stopPrank();
    }

    function testAutoForwardThreshold() public {
        // Collect 1.5 ETH (above threshold)
        vm.startPrank(authorizedCaller);
        uint256 feeAmount = 1.5 ether;
        
        uint256 treasuryBalanceBefore = TREASURY_ADDRESS.balance;
        
        treasury.collectFee{value: feeAmount}(address(0), feeAmount);

        uint256 treasuryBalanceAfter = TREASURY_ADDRESS.balance;

        // Should auto-forward
        assertGt(treasuryBalanceAfter, treasuryBalanceBefore, "Fees not auto-forwarded");

        vm.stopPrank();
    }

    function testManualForward() public {
        vm.startPrank(authorizedCaller);
        
        uint256 feeAmount = 0.5 ether;
        treasury.collectFee{value: feeAmount}(address(0), feeAmount);

        vm.stopPrank();

        uint256 treasuryBalanceBefore = TREASURY_ADDRESS.balance;
        
        treasury.forwardFees(address(0));

        uint256 treasuryBalanceAfter = TREASURY_ADDRESS.balance;

        assertGt(treasuryBalanceAfter, treasuryBalanceBefore, "Manual forward failed");
    }

    function testEmergencyWithdraw() public {
        // Collect fees from authorized caller
        vm.prank(authorizedCaller);
        treasury.collectFee{value: 1 ether}(address(0), 1 ether);

        // Emergency withdraw as owner
        address recipient = address(0x3);
        treasury.emergencyWithdraw(address(0), 0.5 ether, recipient);

        assertEq(recipient.balance, 0.5 ether, "Emergency withdraw failed");
    }

    function testBatchForward() public {
        vm.startPrank(authorizedCaller);
        
        // Collect multiple token fees
        treasury.collectFee{value: 0.5 ether}(address(0), 0.5 ether);
        
        token.approve(address(treasury), 10 ether);
        treasury.collectFee(address(token), 10 ether);

        vm.stopPrank();

        address[] memory tokens = new address[](2);
        tokens[0] = address(0);
        tokens[1] = address(token);

        treasury.forwardMultipleTokens(tokens);

        // Check both were forwarded
        (uint256 ethAccumulated,,) = treasury.getTokenBalance(address(0));
        (uint256 tokenAccumulated,,) = treasury.getTokenBalance(address(token));

        assertEq(ethAccumulated, 0, "ETH not forwarded");
        assertEq(tokenAccumulated, 0, "Tokens not forwarded");
    }

    receive() external payable {}
}
