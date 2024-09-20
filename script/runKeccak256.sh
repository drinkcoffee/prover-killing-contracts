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
    script/Keccak256Me.s.sol:RunKeccak \
    "0xc2d542Bcd263Df3fEAaB5A699637dbc03381d4AF" 

