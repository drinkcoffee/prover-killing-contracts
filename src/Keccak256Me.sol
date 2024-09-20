// Copyright (c) Peter Robinson 2024
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * Aim to call keccak256 as many times as possible in a block. See test code for iteration count.
 * 
 * Keccak256 is described here: https://ethereum.github.io/execution-specs/src/ethereum/london/vm/instructions/keccak.py.html
 * That is:
 * Pops off the stack: offset into memory, size in bytes of information to digest.
 * Pushes onto the stack: the result.
 * Gas usage:
 *   30 gas + 6 gas per word digested + memory expansion costs.
 *
 * Assuming the same memory is digested, there should be no memory expansion costs, after the first time 
 * through a loop. Hence, an optimal implementation should use 36 gas + maybe another 10 gas to do the 
 * pushing and popping required to set-up and remove parameters + a loop with a counter.
 */
contract Keccak256Me {
    event FinalResult(bytes32 _result);
    event Iterations(uint256 _iterations);
    event FinalResult1(bytes32 _a, bytes32 _b, bytes32 _c, bytes32 _d, bytes32 _e, bytes32 _f, bytes32 _g, bytes32 _h, bytes32 _i, bytes32 _j);

    // Approx 638 gas per keccak256
    function solLoop1(uint256 _iterations) public {
        bytes32 result = 0;
        for (uint256 i = 0; i < _iterations; i++) {
            bytes memory toBeHashed = abi.encodePacked(result);
            result = keccak256(toBeHashed);
        }
        emit FinalResult(result);
    }

    // Approx 111 gas per keccak256
    function solLoop2(uint256 _iterations) public {
        bytes memory toBeHashed = abi.encodePacked(bytes32(0));
        for (uint256 i = 0; i < _iterations; i++) {
            keccak256(toBeHashed);
        }
        emit Iterations(_iterations);
    }

    // Approx 90 gas per keccak256
    function yulLoop1(uint256 _iterations) public {
        bytes32 result = 0;
        assembly {
            let zero := returndatasize()
            let one := 1

            for { let i := 0 } lt(i, _iterations) { i := add(i, one) } {
                // Keccak256 a single byte. Cost should be 30 gas for keccak256 + 
                //  6 gas to keccak one word + memory expansion cost for first call.
                result := keccak256(zero, one)
            }
        }
        emit FinalResult(result);
    }

    // Approx 52 gas per keccak256
    function yul2(uint256 _iterations) public {
        bytes32 a;
        bytes32 b;
        bytes32 c;
        bytes32 d;
        bytes32 e;
        bytes32 f;
        bytes32 g;
        bytes32 h;
        bytes32 i;
        bytes32 j;

        assembly {
            let zero := 0
            let one := 1

            for { let z := 0 } lt(z, _iterations) { z := add(z, one) } {
                // Keccak256 a single byte. Cost should be 30 gas for keccak256 + 
                //  6 gas to keccak one word + memory expansion cost for first call.
                a := keccak256(0, 1)
                b := keccak256(1, 1)
                c := keccak256(2, 1)
                d := keccak256(3, 1)
                e := keccak256(4, 1)
                f := keccak256(5, 1)
                g := keccak256(6, 1)
                h := keccak256(7, 1)
                i := keccak256(8, 1)
                j := keccak256(9, 1)
                
            }
        }
        emit FinalResult1(a, b, c, d, e, f, g, h, i, j);
    }


}
