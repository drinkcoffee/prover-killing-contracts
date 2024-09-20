// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {Pairing} from "../src/Pairing.sol";

contract PairingCheck is Script {
    function run(address _store) public {
        Pairing store = Pairing(_store);

        vm.broadcast();
        store.checkBigBadEcPairingExpectPass2(800);
    }
}
