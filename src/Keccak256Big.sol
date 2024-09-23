// Copyright (c) Peter Robinson 2024
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Keccak256 as much data in one transaction as possible.
 * 
 */
contract Keccak256Big {
    event FinalResult(bytes32 _result);

    /**
     * Execute keccak256 over a large amount of data (which is all 0x00).
     * The costs of this code will primarily be the memory expansion cost
     * and the cost of calling keccak256.
     */
    function sol(uint256 _size) public {
        bytes memory data = new bytes(_size);
        bytes32 result = keccak256(data);
        emit FinalResult(result);
    }
}
