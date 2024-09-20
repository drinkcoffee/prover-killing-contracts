// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {Keccak256Me} from "../src/Keccak256Me.sol";

contract RunKeccak is Script {
    function run(address _store) public {
        Keccak256Me store = Keccak256Me(_store);

        vm.startBroadcast();
        store.yul2(56995);
//        store.yul2(57400);
//        store.yul2(57564);
        vm.stopBroadcast();
    }
}
