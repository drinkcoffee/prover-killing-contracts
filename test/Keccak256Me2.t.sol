// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Keccak256Me2Deploy} from "../src/Keccak256Me2Deploy.sol";

interface Keccak256Me2 {
  function run() external;
}

contract Keccak256Me2Test is Test {
    Keccak256Me2 keccak256Me;

    function setUp() public {
        // Deploy a new instance of src/Keccak256Me2.huff
        address addr = address(new Keccak256Me2Deploy());
        keccak256Me = Keccak256Me2(addr);
    }

    // Execute 694,100 keccak256s per 30M block.
    function testRun() public {
        keccak256Me.run{gas:30000000}();
    }
}
