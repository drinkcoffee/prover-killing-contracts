// Copyright (c) Peter Robinson 2024
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * Call blockhash(block) a lot.
 * 
 */
contract BlockHash {
    event FinalResult(bytes32 _result);

    function solLoop1(uint256 _iterations) public {
        uint256 blockNumMinus256 = block.number - 256;
        bytes32 result = 0;
        for (uint256 i = 0; i < _iterations; i++) {
            uint256 num = blockNumMinus256 + _iterations % 255;
            bytes32 temp = blockhash(num);
            result = bytes32(uint256(result) ^ uint256(temp));
        }
        emit FinalResult(result);
    }

    function solLoop2(uint256 _iterations) public {
        uint256 blockNumMinus256 = block.number - 256;
        uint256 blockNumMinus255 = block.number - 255;
        uint256 blockNumMinus254 = block.number - 254;
        uint256 blockNumMinus253 = block.number - 253;
        uint256 blockNumMinus252 = block.number - 252;
        uint256 blockNumMinus251 = block.number - 251;
        uint256 blockNumMinus250 = block.number - 250;
        uint256 blockNumMinus249 = block.number - 249;

        bytes32 result = 0;
        for (uint256 i = 0; i < _iterations; i++) {
            bytes32 temp256 = blockhash(blockNumMinus256);
            bytes32 temp255 = blockhash(blockNumMinus255);
            bytes32 temp254 = blockhash(blockNumMinus254);
            bytes32 temp253 = blockhash(blockNumMinus253);
            bytes32 temp252 = blockhash(blockNumMinus252);
            bytes32 temp251 = blockhash(blockNumMinus251);
            bytes32 temp250 = blockhash(blockNumMinus250);
            bytes32 temp249 = blockhash(blockNumMinus249);
            result = bytes32(temp249 ^ temp250 ^ temp251 ^ temp252 ^ temp253 ^ temp254 ^ temp255 ^ temp256);
        }
        emit FinalResult(result);
    }

    function yul1(uint256 _iterations) public {
        uint256 blockNumMinus256 = block.number - 256;
        bytes32 result;

        assembly {
            let zero := 0
            let one := 1

            for { let z := zero } lt(z, _iterations) { z := add(z, one) } {
                result := blockhash(blockNumMinus256)
            }
        }
        emit FinalResult(result);
    }

    function yul2(uint256 _iterations) public {
        uint256 blockNumMinus256 = block.number - 256;
        uint256 blockNumMinus255 = block.number - 255;
        uint256 blockNumMinus254 = block.number - 254;
        uint256 blockNumMinus253 = block.number - 253;
        uint256 blockNumMinus252 = block.number - 252;
        uint256 blockNumMinus251 = block.number - 251;
        uint256 blockNumMinus250 = block.number - 250;
        uint256 blockNumMinus249 = block.number - 249;
        bytes32 result;

        assembly {
            let zero := 0
            let one := 1

            for { let z := zero } lt(z, _iterations) { z := add(z, one) } {
                result := xor(result, blockhash(blockNumMinus256))
                result := xor(result, blockhash(blockNumMinus255))
                result := xor(result, blockhash(blockNumMinus254))
                result := xor(result, blockhash(blockNumMinus253))
                result := xor(result, blockhash(blockNumMinus252))
                result := xor(result, blockhash(blockNumMinus251))
                result := xor(result, blockhash(blockNumMinus250))
                result := xor(result, blockhash(blockNumMinus249))
            }
        }
        emit FinalResult(result);
    }

}
