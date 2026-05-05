// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Storage3Manager} from "../src/Storage3Manager.sol";

contract Storage3ManagerTest is Test {
    event Result(uint256 _val);

    Storage3Manager public store;

    function setUp() public {
        store = new Storage3Manager();


        // Fill enough locations to cover loadCold test case.
        for (uint256 i = 0; i < 20; i++) {
            store.deploy(100);
        }
    }

    function testColdStore() public {
        store.loadCold(1000);
    }

    // This won't give correct results for the test code as the locations will be host.
    function testColdLoad() public {
        store.loadCold(2000);
    }
}
