// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BlockHash} from "../src/BlockHash.sol";

contract BlockHashTest is Test {
    BlockHash public blockHash;

    function setUp() public {
        blockHash = new BlockHash();
        vm.roll(block.number + 1000);
    }

    // 286 gas per iteration (per blockhash)
    function testSolLoop1() public {
        blockHash.solLoop1(100000);
    }

    // approx 80 gas per block hash
    function testSolLoop2() public {
        blockHash.solLoop2(100000);
    }

    // approx 71 gas per block hash
    function testYul1() public {
        blockHash.yul1(100000);
    }

    // approx 40 gas per block hash
    function testYul2() public {
        blockHash.yul2(100000);
    }
}
