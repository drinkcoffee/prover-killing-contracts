// Copyright (c) Peter Robinson 2024
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ModExp {
    event Result(bytes _result);

    function simpleCheck() external view {
        bytes memory b1 = hex"07";
        bytes memory e1 = hex"02";
        bytes memory m1 = hex"08";
        bytes memory x1 = hex"01";
        bytes memory r1 = modExp(b1, e1, m1);
        require(r1.length == x1.length, "length");
        require(r1[0] == x1[0], "ofs 0");
    }

    function modExp(bytes memory _base, bytes memory _exponent, bytes memory _modulus) 
        public view returns (bytes memory result) {

        bytes memory input = bytes.concat(
                bytes32(_base.length), bytes32(_exponent.length), bytes32(_modulus.length), 
                _base, _exponent, _modulus);
        uint256 inputLen = input.length;
        uint256 resultLen = _modulus.length;
        result = new bytes(resultLen);
        assembly {
            pop(staticcall(sub(gas(), 2000), 5, add(input, 0x20), inputLen, add(result, 0x20), resultLen))
        }
    }

    function killer(uint256 _size) public {
        bytes memory mod = new bytes(_size);
        bytes memory base = new bytes(_size - 1);
        bytes memory exp = new bytes(_size - 1);
        for (uint256 i = 0; i < _size - 1; i++) {
            bytes1 val = bytes1(uint8(i));
            mod[i] = val;
            base[i] = val;
            exp[i] = val;
        }
        mod[_size-1] = bytes1(0xDB);

        bytes memory result = modExp(base, exp, mod);
        emit Result(result);
    }

}

