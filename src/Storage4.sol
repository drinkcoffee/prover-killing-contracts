// Copyright (c) Peter Robinson 2026
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * To be used with StorageManager
 */
contract Storage4 {
    uint256 private val;

    uint256 private constant FILL_PER_CALL = 1000;
    mapping(uint256 => uint256) private info;
    uint256 public fillOfs;

    // Fill up storage 1000 slots at a time. Should be approx 22,000,000 gas per call.
    function fillUpStorage() external {
        uint256 fillOfsCached = fillOfs;
        for (uint256 i = 0; i < FILL_PER_CALL; i++) {
            info[fillOfsCached + i] = i + 1;
        }
        fillOfs = fillOfsCached + FILL_PER_CALL;
    }

    function storeCold(uint256 _val) external {
        val = _val;
    }

    function loadCold() external view returns (uint256) {
        return val;
    }
}
