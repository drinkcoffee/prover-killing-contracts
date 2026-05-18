# script2

Python CLI for interacting with Storage4Manager contracts.

## Setup

Create and activate a virtual environment, then install dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

To deactivate the virtual environment:

```bash
deactivate
```


## Configuration

The script reads from the `.env` file in the project root. The following variables are required:

| Variable | Description |
|---|---|
| `PRIVATE_KEY` | Private key of the transaction sender |
| `STORAGE4MANAGER` | Deployed address of the Storage4Manager contract |

The RPC endpoint is resolved in this order:
1. `RPC` variable in `.env` (if set)
2. `https://rpc.immutable.com` if `USE_MAINNET=1`
3. `https://rpc.testnet.immutable.com` otherwise (default)

## Commands

### storageTestInitPart2

Calls `fillUpStorage()` on a range of Storage3 contracts managed by Storage3Manager.
Fetches `--iterations` contract addresses starting at `--offset` via `getContracts()`,
then sends a `fillUpStorage()` transaction to each one in sequence.

```bash
python main.py storageTestInitPart2 --offset <offset> --iterations <iterations>
```

**Parameters:**

| Parameter | Description |
|---|---|
| `--offset` | Index of the first contract to process |
| `--iterations` | Number of contracts to process |

**Example** — process contracts 0 through 99:

```bash
python main.py storageTestInitPart2 --offset 0 --iterations 100
```

**Example** — process the next batch, contracts 100 through 199:

```bash
python main.py storageTestInitPart2 --offset 100 --iterations 100
```

The script prints the transaction hash for each contract as it is processed and exits with a non-zero status on the first failure.

### storeCold

Calls `storeCold(uint256 _iteration, uint256 _val)` on the Storage4Manager contract.

```bash
python main.py storeCold --iteration <iteration> --val <val>
```

**Parameters:**

| Parameter | Description |
|---|---|
| `--iteration` | Value to pass as `_iteration` |
| `--val` | Value to pass as `_val` |

**Example:**

```bash
python main.py storeCold --iteration 1000 --val 42
```

The script prints the transaction hash on success and exits with a non-zero status on failure.
