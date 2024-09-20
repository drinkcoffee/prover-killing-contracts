#!/bin/bash

RPC=https://rpc.testnet.immutable.com


echo PKEY: $PKEY
echo RPC URL: $RPC

i=1
while [ $i -le 100 ]
do
    echo $i

    forge script --rpc-url $RPC \
        --private-key $PKEY \
        --priority-gas-price 10000000000 \
        --with-gas-price     10000000100 \
        --sig "run(address _store)" \
        -vvv \
        --broadcast \
        script/FillStorage.s.sol:FillStorage \
        "0x221e15e555c22e92762352d19C90Aa605bD6c689" 

    i=$(($i+1))
done


#    --gas-estimate-multiplier 1 \
