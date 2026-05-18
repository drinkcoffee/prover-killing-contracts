#!/usr/bin/env python3
"""
CLI tool for interacting with Storage4Manager contracts.

Setup:
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt

Usage:
    python main.py storageTestInitPart2 --offset 0 --iterations 100
"""

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

from dotenv import load_dotenv


def load_config():
    env_path = Path(__file__).parent.parent / ".env"
    if env_path.exists():
        load_dotenv(env_path)
    else:
        load_dotenv()

    private_key = os.environ.get("PRIVATE_KEY")
    rpc = os.environ.get("RPC")

    if not rpc:
        use_mainnet = os.environ.get("USE_MAINNET", "0")
        if use_mainnet == "1":
            rpc = "https://rpc.immutable.com"
        else:
            rpc = "https://rpc.testnet.immutable.com"

    storageManager = os.environ.get("STORAGE4MANAGER")
    return private_key, rpc, storageManager


def parse_address_array(raw: str) -> list[str]:
    raw = raw.strip()
    if raw.startswith("[") and raw.endswith("]"):
        raw = raw[1:-1]
    if not raw.strip():
        return []
    addresses = [a.strip() for a in raw.split(",") if a.strip()]
    valid = [a for a in addresses if re.match(r"^0x[0-9a-fA-F]{40}$", a)]
    if len(valid) != len(addresses):
        print(f"Warning: some entries in the returned array were not valid addresses", file=sys.stderr)
    return valid


def get_contracts(rpc: str, storageManager: str, offset: int, iterations: int) -> list[str]:
    result = subprocess.run(
        [
            "cast", "call",
            "--rpc-url", rpc,
            storageManager,
            "getContracts(uint256,uint256)(address[])",
            str(offset),
            str(iterations),
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"Error calling getContracts: {result.stderr}", file=sys.stderr)
        sys.exit(1)
    return parse_address_array(result.stdout)


def fill_up_storage(rpc: str, private_key: str, address: str) -> str:
    result = subprocess.run(
        [
            "cast", "send",
            "--rpc-url", rpc,
            "--private-key", private_key,
            "--priority-gas-price", "10000000000",
            "--gas-price", "10000000100",
            address,
            "fillUpStorage()",
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())
    # extract tx hash from output
    for line in result.stdout.splitlines():
        if line.startswith("transactionHash"):
            return line.split()[-1]
    return result.stdout.strip()


def store_cold(rpc: str, private_key: str, storageManager: str, iteration: int, val: int) -> str:
    result = subprocess.run(
        [
            "cast", "send",
            "--rpc-url", rpc,
            "--private-key", private_key,
            "--priority-gas-price", "10000000000",
            "--gas-price", "10000000100",
            storageManager,
            "storeCold(uint256,uint256)",
            str(iteration),
            str(val),
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())
    for line in result.stdout.splitlines():
        if line.startswith("transactionHash"):
            return line.split()[-1]
    return result.stdout.strip()


def cmd_store_cold(iteration: int, val: int) -> None:
    private_key, rpc, storageManager = load_config()

    if not private_key:
        print("Error: PRIVATE_KEY not set in .env", file=sys.stderr)
        sys.exit(1)
    if not storageManager:
        print("Error: STORAGE4MANAGER not set in .env", file=sys.stderr)
        sys.exit(1)

    print(f"RPC:              {rpc}")
    print(f"Storage4Manager:  {storageManager}")
    print(f"Iteration:        {iteration}")
    print(f"Val:              {val}")
    print()

    print(f"Calling storeCold({iteration}, {val}) ...", end=" ", flush=True)
    try:
        tx = store_cold(rpc, private_key, storageManager, iteration, val)
        print(f"ok  {tx}")
    except RuntimeError as e:
        print("FAILED")
        print(f"  Error: {e}", file=sys.stderr)
        sys.exit(1)


def cmd_storage_test_init_part2(offset: int, iterations: int) -> None:
    private_key, rpc, storageManager = load_config()

    if not private_key:
        print("Error: PRIVATE_KEY not set in .env", file=sys.stderr)
        sys.exit(1)
    if not storageManager:
        print("Error: STORAGE4MANAGER not set in .env", file=sys.stderr)
        sys.exit(1)

    print(f"RPC:              {rpc}")
    print(f"Storage4Manager:  {storageManager}")
    print(f"Offset:           {offset}")
    print(f"Iterations:       {iterations}")
    print()

    print(f"Fetching {iterations} contracts starting at offset {offset}...")
    contracts = get_contracts(rpc, storageManager, offset, iterations)
    print(f"Received {len(contracts)} contracts")
    print()

    for i, addr in enumerate(contracts):
        abs_index = offset + i
        print(f"[{abs_index}] fillUpStorage {addr} ...", end=" ", flush=True)
        try:
            tx = fill_up_storage(rpc, private_key, addr)
            print(f"ok  {tx}")
        except RuntimeError as e:
            print(f"FAILED")
            print(f"  Error: {e}", file=sys.stderr)
            sys.exit(1)

    print()
    print(f"Done. Processed {len(contracts)} contracts.")


def main() -> None:
    parser = argparse.ArgumentParser(description="Storage4Manager CLI")
    subparsers = parser.add_subparsers(dest="command", required=True)

    part2 = subparsers.add_parser(
        "storageTestInitPart2",
        help="Call fillUpStorage() on a range of Storage3 contracts",
    )
    part2.add_argument("--offset", type=int, required=True, help="Index of first contract to process")
    part2.add_argument("--iterations", type=int, required=True, help="Number of contracts to process")

    cold = subparsers.add_parser(
        "storeCold",
        help="Call storeCold(uint256,uint256) on the Storage4Manager contract",
    )
    cold.add_argument("--iteration", type=int, required=True, help="Iteration value to pass to storeCold")
    cold.add_argument("--val", type=int, required=True, help="Val value to pass to storeCold")

    args = parser.parse_args()

    if args.command == "storageTestInitPart2":
        cmd_storage_test_init_part2(args.offset, args.iterations)
    elif args.command == "storeCold":
        cmd_store_cold(args.iteration, args.val)


if __name__ == "__main__":
    main()
