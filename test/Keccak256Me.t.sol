// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Keccak256Me} from "../src/Keccak256Me.sol";

contract Keccak256MeTest is Test {
    Keccak256Me public keccak256Me;

    function setUp() public {
        keccak256Me = new Keccak256Me();
    }

    // NOTE: 1x keccak256 per iteration
    function testSolLoop1() public {
        keccak256Me.solLoop1(46996);
    }

    // NOTE: 1x keccak256 per iteration
    function testSolLoop2() public {
        keccak256Me.solLoop2(270210);
    }

    // NOTE: 1x keccak256 per iteration
    function testYulLoop1() public {
        keccak256Me.yulLoop1(333255);
    }

    // NOTE: 10x keccak256 per iteration
    function testYul2() public {
        keccak256Me.yul2(57564);
    }

}
