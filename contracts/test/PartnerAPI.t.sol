// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../core/PartnerAPI.sol";

contract PartnerAPITest is Test {
    PartnerAPI public partnerAPI;
    address public owner;
    address public partner1;
    address public partner2;
    address public user;

    function setUp() public {
        owner = address(this);
        partner1 = address(0x1);
        partner2 = address(0x2);
        user = address(0x3);

        partnerAPI = new PartnerAPI();

        vm.deal(address(partnerAPI), 10 ether);
    }

    function testRegisterPartner() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 50); // 0.5% fee share

        (uint256 feeShare, uint256 earned, uint256 volume, bool active) = partnerAPI.getPartnerInfo(partner1);

        assertEq(feeShare, 50, "Fee share incorrect");
        assertEq(earned, 0, "Initial earned should be 0");
        assertEq(volume, 0, "Initial volume should be 0");
        assertTrue(active, "Partner should be active");
    }

    function testReferralCodeMapping() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 50);

        address mappedPartner = partnerAPI.getPartnerByCode(code);
        assertEq(mappedPartner, partner1, "Referral code mapping failed");
    }

    function testCalculatePartnerFee() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 50); // 0.5%

        uint256 totalFee = 1 ether;
        uint256 partnerFee = partnerAPI.calculatePartnerFee(partner1, totalFee);

        // 0.5% of 1 ether = 0.005 ether
        assertEq(partnerFee, 0.005 ether, "Partner fee calculation incorrect");
    }

    function testRecordReferral() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 50);

        vm.startPrank(address(this));
        partnerAPI.recordReferral(user, code, 1000 ether);
        vm.stopPrank();

        (, , uint256 volume, ) = partnerAPI.getPartnerInfo(partner1);
        assertEq(volume, 1000 ether, "Volume not recorded");
    }

    function testTierUpgrade() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 10); // Start at 0.1%

        // Record volume to trigger tier upgrade
        partnerAPI.recordReferral(user, code, 150000 ether); // Should upgrade to 0.2% tier

        (uint256 feeShare, , , ) = partnerAPI.getPartnerInfo(partner1);
        assertEq(feeShare, 20, "Tier upgrade failed");
    }

    function testDistributeFees() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 50);

        uint256 balanceBefore = partner1.balance;
        
        partnerAPI.distributeFees(partner1, address(0), 1 ether);

        uint256 balanceAfter = partner1.balance;
        assertEq(balanceAfter - balanceBefore, 1 ether, "Fee distribution failed");
    }

    function testUpdatePartnerFeeShare() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 50);

        partnerAPI.updatePartnerFeeShare(partner1, 100);

        (uint256 feeShare, , , ) = partnerAPI.getPartnerInfo(partner1);
        assertEq(feeShare, 100, "Fee share update failed");
    }

    function testDeactivatePartner() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 50);

        partnerAPI.deactivatePartner(partner1);

        (, , , bool active) = partnerAPI.getPartnerInfo(partner1);
        assertFalse(active, "Partner deactivation failed");
    }

    function testInactivePartnerFeeCalculation() public {
        bytes32 code = keccak256("PARTNER1");
        partnerAPI.registerPartner(partner1, code, 50);
        partnerAPI.deactivatePartner(partner1);

        uint256 partnerFee = partnerAPI.calculatePartnerFee(partner1, 1 ether);
        assertEq(partnerFee, 0, "Inactive partner should not receive fees");
    }

    function testMultipleReferralTiers() public view {
        PartnerAPI.ReferralTier[] memory tiers = partnerAPI.getReferralTiers();
        
        assertTrue(tiers.length >= 4, "Should have at least 4 tiers");
        assertEq(tiers[0].minVolume, 0, "First tier min volume should be 0");
        assertEq(tiers[0].feeShareBps, 10, "First tier should be 0.1%");
    }
}
