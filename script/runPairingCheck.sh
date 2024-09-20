#!/bin/bash

RPC=https://rpc.testnet.immutable.com


echo PKEY: $PKEY
echo RPC URL: $RPC

forge script --rpc-url $RPC \
    --private-key $PKEY \
    --priority-gas-price 10000000000 \
    --with-gas-price     10000000100 \
    --gas-estimate-multiplier 96 \
    --sig "run(address _addr)" \
    -vvv \
    --broadcast \
    script/PairingCheck.s.sol:PairingCheck \
    "0x4062AD62E9b669804Db76d7646e0a2b153E148e8"

