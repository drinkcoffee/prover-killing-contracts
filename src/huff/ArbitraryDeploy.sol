// Copyright (c) Peter Robinson 2024
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ArbitraryDeploy} from "./ArbitraryDeploy.sol";

abstract contract ArbitraryDeploy {
    constructor(bytes memory _runtimeCode) {
        uint256 memOfs = dataPtr(_runtimeCode);
        uint256 len = _runtimeCode.length;
        copy(memOfs, 0, len);

        assembly {
            return(0, len)
        }
    }


    // From https://github.com/ethereum/solidity-examples/blob/master/src/unsafe/Memory.sol
    // Size of a word, in bytes.
    uint internal constant WORD_SIZE = 32;

    // Copy 'len' bytes from memory address 'src', to address 'dest'.
    // This function does not check the or destination, it only copies
    // the bytes.
    function copy(uint src, uint dest, uint len) internal pure {
        // Copy word-length chunks while possible
        for (; len >= WORD_SIZE; len -= WORD_SIZE) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += WORD_SIZE;
            src += WORD_SIZE;
        }

        // Copy remaining bytes
        uint mask = 256 ** (WORD_SIZE - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    function dataPtr(bytes memory bts) internal pure returns (uint addr) {
        assembly {
            addr := add(bts, /*BYTES_HEADER_SIZE*/32)
        }
    }

}