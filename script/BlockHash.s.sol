// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {BlockHash} from "../src/BlockHash.sol";

contract BlockHashRunner is Script {
    function run(address _addr) public {
        BlockHash blockHash = BlockHash(_addr);

        vm.broadcast();
        blockHash.yul2(91000);
    }
}
