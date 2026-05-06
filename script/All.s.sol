// Copyright (c) Whatgame Studios 2026
// SPDX-License-Identifier: PROPRIETARY
pragma solidity ^0.8;

import {Script, console} from "forge-std/Script.sol";
import {Storage3} from "../src/Storage3.sol";
import {Storage3Manager} from "../src/Storage3Manager.sol";
import {Storage4Manager} from "../src/Storage4Manager.sol";

contract AllScript is Script {
    uint256 private constant CONTRACT_BATCH_SIZE = 10;
    uint256 private constant TOTAL_CONTRACTS = 5000;
    uint256 private constant ITERATIONS = TOTAL_CONTRACTS / CONTRACT_BATCH_SIZE;

    function deployStorage3Manager() public {
        //address deployer = vm.envAddress("DEPLOYER_ADDRESS");
        vm.broadcast();
        Storage3Manager impl = new Storage3Manager();
        console.log("Implementation address: ", address(impl));
    }


    // Run 1000 times to deploy 10,000 contracts
    function storageTestInitPart1() public {
        address storage3ManagerAddr = vm.envAddress("STORAGE3MANAGER");
        Storage3Manager storage3Manager = Storage3Manager(storage3ManagerAddr);

        // Deploy lots of contracts for cold storage and cold load tests
        // for (uint256 i = 0; i < ITERATIONS; i++) {
        //     vm.broadcast();
        //     storage3Manager.deploy(CONTRACT_BATCH_SIZE);
        // }
        for (uint256 i = 0; i < 1; i++) {
            vm.broadcast();
            storage3Manager.deploy(CONTRACT_BATCH_SIZE);
        }

    }

    function storageTestInitPart2() public {
        address storage3ManagerAddr = vm.envAddress("STORAGE3MANAGER");
        Storage3Manager storage3Manager = Storage3Manager(storage3ManagerAddr);

        address[] memory storeContracts = storage3Manager.getContracts(0, TOTAL_CONTRACTS);

        // Deploy lots of contracts for cold storage and cold load tests
//        for (uint256 i = 0; i < TOTAL_CONTRACTS; i++) {
        for (uint256 i = 0; i < 1; i++) {
            vm.broadcast();
            Storage3(storeContracts[i]).fillUpStorage();
        }
    }

    function storageTestStore() public {
        address storage3ManagerAddr = vm.envAddress("STORAGE3MANAGER");
        Storage3Manager storage3Manager = Storage3Manager(storage3ManagerAddr);

        // Deploy lots of contracts for cold storage and cold load tests
        for (uint256 i = 0; i < TOTAL_CONTRACTS; i++) {
            vm.broadcast();
            storage3Manager.storeCold(1000);
        }
    }

    function storageTestLoad() public {
        address storage3ManagerAddr = vm.envAddress("STORAGE3MANAGER");
        Storage3Manager storage3Manager = Storage3Manager(storage3ManagerAddr);

        // Deploy lots of contracts for cold storage and cold load tests
        for (uint256 i = 0; i < TOTAL_CONTRACTS; i++) {
            vm.broadcast();
            storage3Manager.storeCold(1000);
        }
    }


    function deployStorage4Manager() public {
        //address deployer = vm.envAddress("DEPLOYER_ADDRESS");
        vm.broadcast();
        Storage4Manager impl = new Storage4Manager();
        console.log("Implementation address: ", address(impl));
    }


}
