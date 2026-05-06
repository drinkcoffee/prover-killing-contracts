// Copyright (c) Peter Robinson 2026
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Storage4} from "./Storage4.sol";

/**
 * To be used with Storage4
 */
contract Storage4Manager {
    event FinalResult(uint256 _result);
    address[] private contracts;

    function deploy(uint256 _iteration) external {
        for (uint256 i = 0; i < _iteration; i++) {
            Storage4 store = new Storage4();
            contracts.push(address(store));
        }
    }

    function storeCold(uint256 _iteration, uint256 _val) external {
        for (uint256 i = 0; i < _iteration; i++) {
            Storage4(contracts[i]).storeCold(i + _val);
        }
    }

    function loadCold(uint256 _iteration) external {
        uint256 val = 0;
        for (uint256 i = 0; i < _iteration; i++) {
            val += Storage4(contracts[i]).loadCold();
        }
        emit FinalResult(val);
    }

    function getContracts(uint256 _ofs, uint256 _len) external view returns (address[] memory) {
        address[] memory ret = new address[](_len);
        for (uint256 i = 0; i < _len; i++) {
            ret[i] = contracts[_ofs + i];
        }
        return ret;
    }

    function getContractsLength() external view returns (uint256) {
        return contracts.length;
    }
}
