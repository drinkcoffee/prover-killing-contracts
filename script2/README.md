# script2

Python CLI for interacting with Storage3Manager contracts.

## Setup

Create and activate a virtual environment, then install dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Configuration

The script reads from the `.env` file in the project root. The following variables are required:

| Variable | Description |
|---|---|
| `PRIVATE_KEY` | Private key of the transaction sender |
| `STORAGE3MANAGER` | Deployed address of the Storage3Manager contract |

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
