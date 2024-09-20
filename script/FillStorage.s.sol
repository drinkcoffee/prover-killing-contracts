// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {Storage} from "../src/Storage.sol";

contract FillStorage is Script {
    function run(address _store) public {
        Storage store = Storage(_store);

//        for (uint256 i = 0; i < 10; i++) {
            vm.startBroadcast();
            store.fillUpStorage();
            vm.stopBroadcast();
//        }
    }
}
