#!/bin/bash

RPC=https://rpc.testnet.immutable.com


echo PKEY: $PKEY
echo RPC URL: $RPC

forge create --rpc-url $RPC \
    --value 0000000000000000000 \
    --private-key $PKEY \
    --priority-gas-price 10000000000 \
    --gas-price 10000000100 \
    src/Keccak256Me2Deploy.sol:Keccak256Me2Deploy
