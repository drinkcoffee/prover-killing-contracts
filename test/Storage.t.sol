// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Storage} from "../src/Storage.sol";

contract StorageTest is Test {
    event Result(uint256 _val);

    Storage public store;

    function setUp() public {
        store = new Storage();
        // TODO should call this 160,000 to fill up the storage to 16,000,000 enstrie
        store.fillUpStorage();

    }

    // Note: 10x sloads compared to iteration count
    function testLoadHot() public {
        store.loadHot(26650);
    }

    // Note: 10x sloads compared to iteration count
    function testLoadHot3() public {
        store.loadHot3(28267);
    }

    function testCold() public {
        store.loadCold(13468);
    }

}
