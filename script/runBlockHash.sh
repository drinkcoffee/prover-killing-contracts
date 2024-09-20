#!/bin/bash

RPC=https://rpc.testnet.immutable.com


echo PKEY: $PKEY
echo RPC URL: $RPC

forge script --rpc-url $RPC \
    --private-key $PKEY \
    --priority-gas-price 10000000000 \
    --with-gas-price     10000000100 \
    --gas-estimate-multiplier 95 \
    --sig "run(address _store)" \
    -vvv \
    --broadcast \
    script/BlockHash.s.sol:BlockHashRunner \
    "0xf55569f8dC27593090b0Cfb8CB7787b4d361C3Bb"

