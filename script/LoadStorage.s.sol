// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {Storage} from "../src/Storage.sol";

contract LoadStorage is Script {
    function run(address _store) public {
        Storage store = Storage(_store);

        vm.startBroadcast();
//        store.loadHot3(28200);
        store.loadHot3(28200);
//        store.loadHot3(18266);
//        store.loadHot3(28267);
        vm.stopBroadcast();
    }
}
