// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Keccak256Big} from "../src/Keccak256Big.sol";

contract Keccak256BigTest is Test {
    Keccak256Big public keccak256Big;

    function setUp() public {
        keccak256Big = new Keccak256Big();
    }

    function testSol() public {
        keccak256Big.sol(3850000);
    }
}
