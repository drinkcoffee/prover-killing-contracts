// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ModExp} from "../src/ModExp.sol";

contract ModExpTest is Test {
    event Result(bool _verified);

    ModExp public modExp;

    function setUp() public {
        modExp = new ModExp();
    }

    function test1() public {
        modExp.killer(890);
    }
}
