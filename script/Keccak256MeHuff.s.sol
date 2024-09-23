// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {Keccak256Me2Deploy} from "../src/huff/Keccak256Me2Deploy.sol";

interface Keccak256Me2 {
  function run() external;
}

contract RunKeccakHuff is Script {
    Keccak256Me2 keccak256Me;
    function run(address deployedAddress) public {
        keccak256Me = Keccak256Me2(deployedAddress);
        vm.startBroadcast();
        keccak256Me.run{gas:30000000}();
        vm.stopBroadcast();
    }
}
