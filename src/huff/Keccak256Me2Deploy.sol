// Copyright (c) Peter Robinson 2024
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


import {ArbitraryDeploy} from "./ArbitraryDeploy.sol";

contract Keccak256Me2Deploy is ArbitraryDeploy {
    // The bytecode below is the output of calling 
    //  huffc src/Keccak256Me2.huff --bin-runtime
    bytes private constant CODE = hex"61110060205b803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050803d2050815a116100055700";

    constructor() ArbitraryDeploy(CODE) {
    }

    // The code below never gets deployed. However, it helps the block explorer create a function.
    uint256 private notReal;

    function run() external {
        notReal = 3;
    }
}