// Copyright (c) Peter Robinson 2024
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * Use storage to result in many keccak256 operations.
 */
contract Storage {
    event FinalResult(uint256 _result);

    uint256 private constant FILL_PER_CALL = 200;

    // Have these as storage slots 0 to 9. Storage slot 1 must be set to 1 for loadHot3 to work.
    uint256 private val0 = 1;
    uint256 private val1 = 1;
    uint256 private val2 = 1;
    uint256 private val3 = 1;
    uint256 private val4 = 1;
    uint256 private val5 = 1;
    uint256 private val6 = 1;
    uint256 private val7 = 1;
    uint256 private val8 = 1;
    uint256 private val9 = 1;

    mapping(uint256 => uint256) private info;
    uint256 public fillOfs;

    // Fill up storage 100 slots at a time. Should be approx 4,400,000 gas per call.
    function fillUpStorage() external {
        uint256 fillOfsCached = fillOfs;
        for (uint256 i = 0; i < FILL_PER_CALL; i++) {
            info[fillOfsCached + i] = i + 1;
        }
        fillOfs = fillOfsCached + FILL_PER_CALL;
    }


    // sload from the same storage slots. 
    // The first time slots are loaded should code 2100 gas.
    // The second time slots are loaded should cost 100 gas.
    function loadHot(uint256 _iterations) public {
        uint256 result = 0;
        unchecked {
            for (uint256 i = 0; i < _iterations; i++) {
                result += val0 + val1 + val2 + val3 + val4 + val5 + val6 + val7 + val8 + val9;
            }
        }
        emit FinalResult(result);
    }

    // sload from different storage slots. 
    // Each sload will be a cold load, so will cost 2100 gas.
    function loadCold(uint256 _iterations) public {
        uint256 result = 0;
        unchecked {
            for (uint256 i = 0; i < _iterations; i++) {
                result += info[i];
            }
        }
        emit FinalResult(result);
    }

    // Repeatedly load storage slot 1
    // Averages 106 gas per sload.
    function loadHot3(uint256 _iterations) public {
        uint256 result = 0;
        uint256 iterations = _iterations;
        assembly {
            let one := 1

            for { let i := 0 } lt(i, iterations) { i := add(i, 1) } {
                result := add(result, 
                            sload(sload(sload(sload(sload(sload(sload(sload(sload(sload(one)))))))))))
            }
        }
        emit FinalResult(result);
    }
}
