// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Pairing} from "../src/Pairing.sol";

contract PairingTest is Test {
    event Result(bool _verified);

    Pairing public pairing;

    function setUp() public {
        pairing = new Pairing();
    }

    function testPairingFail() public {
        vm.expectEmit(true, true, true, true);
        emit Result(false);
        pairing.checkBigBadEcPairingExpectFail(806);
    }

    function testPairingFailFaster() public {
        vm.expectEmit(true, true, true, true);
        emit Result(false);
        pairing.checkBigBadEcPairingExpectFail2(838);
    }


    function testPairingPass() public {
        vm.expectEmit(true, true, true, true);
        emit Result(true);
        // Note this must be even for the pairing to work.
        pairing.checkBigBadEcPairingExpectPass(806);
    }

    function testPairingPassFaster() public {
        vm.expectEmit(true, true, true, true);
        emit Result(true);
        // Note this must be even for the pairing to work.
        pairing.checkBigBadEcPairingExpectPass2(836);
    }
}
