# Prover Killing Contracts

The repo contains contracts that transactions can be created with that are likely to be difficult for zk provers to prove. They might take a very long time to prove and might require huge amounts of memory, and thus would be extremely expensive to prove. Additionally, there is a possibility that these contracts hit edge conditions that are not supported by a zk prover. 

These contracts could be used to attack any public zk rollup. They could force the zk prover company to incur huge costs. Additionally, they could be used to delay the posting of proofs, thus having the rollup proofs posted to L1 to be significantly delayed relative to blocks on L2. For example, if blocks consistently take five minutes to prove, and the block period on L2 is two seconds, then the only way to keep the proofs posted to L1 up to date with L2 is to have 150 parallel proving engines. An attacker might craft many blocks in a row with *prover killing transactions* that take 10 minutes to prove, thus needing twice as many parallel proving engines. The system for scaling the proving system may have not been designed for that level of scale. 

zkRollups typically protect their rollup against *prover killing transaction* attacks by limiting the types of transactions that can be processed, or having a budget for how many of a specific type of operation can appear in any one block.


## Contracts

Each of the contracts should be viewed in conjunction with the associated test code. The test code should be used as a guide as to how to use the contracts.

| Contract         | Description    |
|------------------|-----------------------|
|Keccak256Me.sol   | Call keccak256 as many times as possible in a block.  |
|Storage.sol       | Uses the Merkle Patricia Trie to generate many keccak256s when loading storage. |
|Pairing.sol       | Use the EC Pairing precompile across many points. |
|BlockHash.sol     | Request historic block hashes. |
|ModExp.sol        | Modular exponentiation. |

Future work:
* Hash a very large amount of data.
* Create a very large transaction receipt / lots of events / logs.
* Create lots of transactions with lots of receipts.
* Transaction with a lot of very low gas cost transactions, and hence a very long trace.
* Max out recursive call tree.


## Usage

### Set-up
Install:

* Foundry


### Build

```shell
$ forge build
```

### Test

```shell
$ forge test -vvv
```

### Scripts
Deploy the contracts using the `deployXXXX.sh` scripts. Execute functions using the `runXXX.sh` scripts.


### Format

```shell
$ forge fmt
```

## Huff

There are some tests written in Huff. This code has not been as resilient as the code written in Yul and Solidity. Some of it doesn't work yet, probably due to issues with stack usage.

To install Huff:

* Huff: https://docs.huff.sh/get-started/installing/

To build with Huff:

```shell
$ huffc src/huff/Keccak256Me2.huff  --bin-runtime
```
