#!/bin/bash

RPC=https://rpc.testnet.immutable.com


echo PKEY: $PKEY
echo RPC URL: $RPC

forge script --rpc-url $RPC \
    --private-key $PKEY \
    --priority-gas-price 10000000000 \
    --with-gas-price     10000000100 \
    --gas-estimate-multiplier 89 \
    --sig "run(address _store)" \
    -vvv \
    --broadcast \
    script/LoadStorage.s.sol:LoadStorage \
    "0x221e15e555c22e92762352d19C90Aa605bD6c689" 

