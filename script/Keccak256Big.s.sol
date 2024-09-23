// Copyright (c) Peter Robinson 2024
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";

// Open Zeppelin contracts
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {Keccak256Big} from "../src/Keccak256Big.sol";

/**
 * Steps:
 * - Create ./temp directory
 * - Environment variable PKEY must contact the private key for an account that has some native tokens.
 * - Execute: forge script -vvv  --chain-id 13473 --priority-gas-price 10000000000 --with-gas-price 10000000100 --broadcast -g 101 --rpc-url https://rpc.testnet.immutable.com script/Keccak256Big.s.sol:Keccak256Runner
 *
 */
 contract Keccak256Runner is Script {
    string private constant PATH = "./temp/log.txt";

    function run() public {
        vm.writeFile(PATH, "Keccak256Big");

        uint256 deployerPkey = vm.envUint("PKEY");

        address deployer = vm.addr(deployerPkey);
        vm.label(deployer, "deployer");
        vm.writeLine(PATH, "Deployer Address");
        vm.writeLine(PATH, Strings.toHexString(deployer));
        if (deployer.balance == 0) {
            console.logString("ERROR: Deployer has 0 native gas token");
            revert("Deployer has 0 native gas token");
        }

        // Deploy the contract.
        vm.startBroadcast(deployerPkey);
        Keccak256Big keccak256Big = new Keccak256Big();
        vm.stopBroadcast();

        // Execute the test.
        vm.startBroadcast(deployerPkey);
        keccak256Big.sol(3700000);
        vm.stopBroadcast();

        vm.closeFile(PATH);
    }
}

