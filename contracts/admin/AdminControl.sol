// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title AdminControl
 * @notice Comprehensive role-based access control system with timelock
 */
contract AdminControl is AccessControl, ReentrancyGuard {
    bytes32 public constant SUPER_ADMIN_ROLE = keccak256("SUPER_ADMIN_ROLE");
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");
    bytes32 public constant EMERGENCY_ROLE = keccak256("EMERGENCY_ROLE");

    uint256 public constant TIMELOCK_DURATION = 24 hours;

    struct PendingAction {
        bytes32 actionHash;
        uint256 executeTime;
        bool executed;
    }

    mapping(bytes32 => PendingAction) public pendingActions;
    mapping(address => bool) public whitelistedTokens;
    mapping(address => bool) public blacklistedAddresses;

    event RoleGrantedWithTimelock(bytes32 indexed role, address indexed account, uint256 executeTime);
    event ActionScheduled(bytes32 indexed actionHash, uint256 executeTime);
    event ActionExecuted(bytes32 indexed actionHash);
    event EmergencyShutdown(address indexed caller);
    event TokenWhitelisted(address indexed token, bool status);
    event AddressBlacklisted(address indexed account, bool status);

    constructor(address superAdmin) {
        _grantRole(DEFAULT_ADMIN_ROLE, superAdmin);
        _grantRole(SUPER_ADMIN_ROLE, superAdmin);
        _grantRole(EMERGENCY_ROLE, superAdmin);
    }

    /**
     * @notice Schedule a timelock action
     */
    function scheduleAction(bytes32 actionHash) external onlyRole(SUPER_ADMIN_ROLE) {
        require(pendingActions[actionHash].executeTime == 0, "Action already scheduled");

        pendingActions[actionHash] = PendingAction({
            actionHash: actionHash,
            executeTime: block.timestamp + TIMELOCK_DURATION,
            executed: false
        });

        emit ActionScheduled(actionHash, block.timestamp + TIMELOCK_DURATION);
    }

    /**
     * @notice Execute a timelock action
     */
    function executeAction(bytes32 actionHash) external onlyRole(SUPER_ADMIN_ROLE) {
        PendingAction storage action = pendingActions[actionHash];
        require(action.executeTime != 0, "Action not scheduled");
        require(block.timestamp >= action.executeTime, "Timelock not expired");
        require(!action.executed, "Action already executed");

        action.executed = true;
        emit ActionExecuted(actionHash);
    }

    /**
     * @notice Grant operator role
     */
    function grantOperatorRole(address account) external onlyRole(SUPER_ADMIN_ROLE) {
        grantRole(OPERATOR_ROLE, account);
    }

    /**
     * @notice Grant treasury role
     */
    function grantTreasuryRole(address account) external onlyRole(SUPER_ADMIN_ROLE) {
        grantRole(TREASURY_ROLE, account);
    }

    /**
     * @notice Grant emergency role
     */
    function grantEmergencyRole(address account) external onlyRole(SUPER_ADMIN_ROLE) {
        grantRole(EMERGENCY_ROLE, account);
    }

    /**
     * @notice Whitelist a token
     */
    function whitelistToken(address token, bool status) external onlyRole(OPERATOR_ROLE) {
        whitelistedTokens[token] = status;
        emit TokenWhitelisted(token, status);
    }

    /**
     * @notice Blacklist an address
     */
    function blacklistAddress(address account, bool status) external onlyRole(OPERATOR_ROLE) {
        blacklistedAddresses[account] = status;
        emit AddressBlacklisted(account, status);
    }

    /**
     * @notice Emergency shutdown - can be called by EMERGENCY_ROLE
     */
    function emergencyShutdown() external onlyRole(EMERGENCY_ROLE) {
        emit EmergencyShutdown(msg.sender);
    }

    /**
     * @notice Check if address is blacklisted
     */
    function isBlacklisted(address account) external view returns (bool) {
        return blacklistedAddresses[account];
    }

    /**
     * @notice Check if token is whitelisted
     */
    function isTokenWhitelisted(address token) external view returns (bool) {
        return whitelistedTokens[token];
    }
}
