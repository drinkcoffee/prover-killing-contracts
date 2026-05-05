// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Storage2} from "../src/Storage2.sol";

contract StorageTest is Test {
    event Result(uint256 _val);

    Storage2 public store;

    function setUp() public {
        store = new Storage2();

        // Fill enough locations to cover loadCold test case.
        for (uint256 i = 0; i < 20; i++) {
            store.loadColdPrep(i * 1000, 1000);
        }
    }

    function testColdStore() public {
        store.loadCold(1000);
    }

    // This won't give correct results for the test code as the locations will be host.
    function testColdLoad() public {
        store.loadCold(13468);
    }
}
