#!/bin/bash

RPC=https://rpc.testnet.immutable.com


echo PKEY: $PKEY
echo RPC URL: $RPC

forge script --rpc-url $RPC \
    --private-key $PKEY \
    --priority-gas-price 10000000000 \
    --with-gas-price     10000000100 \
    --gas-estimate-multiplier 100 \
    --sig "run(address)" \
    -vvv \
    --broadcast \
    script/Keccak256MeHuff.s.sol:RunKeccakHuff \
    "0xFD1F044cDE155474b6521E749E24a2013A7b5171" 

