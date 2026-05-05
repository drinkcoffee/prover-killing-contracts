// Copyright (c) Peter Robinson 2024 - 2026
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Mass storage operations
 */
contract Storage2 {
    event FinalResult(uint256 _result);

    uint256 private constant LOAD_OFS = 1000000;

    function storeCold(uint256 _iterations) external {
        uint256 result = 0;
        uint256 iterations = _iterations;
        assembly {
            for { let i := 0 } lt(i, iterations) { i := add(i, 1) } {
                sstore(i, i)
            }
        }
        emit FinalResult(result);
    }

    // Arrange storage slots: [0] == 1, [1] == 2 etc
    function loadColdPrep(uint256 _ofs, uint256 _iterations) external {
        _ofs += LOAD_OFS;
        for (uint256 i = _ofs; i < _iterations + _ofs; i++) {
            uint256 next = i + 1;
            assembly {
                sstore(i, next)
            }
        }
    }


    // sload from different storage slots. 
    // Assumes loadColdPrep has been called first to set-up the storage.
    // Each sload will be a cold load, so will cost 2100 gas.
    function loadCold(uint256 _iterations) public {
        uint256 iterations = _iterations;
        uint256 slot = LOAD_OFS;
        assembly {
            for { let i := 0 } lt(i, iterations) { i := add(i, 1) } {
                slot := sload(sload(sload(sload(sload(sload(sload(sload(sload(sload(slot))))))))))
            }
        }
        emit FinalResult(slot);
    }
}
