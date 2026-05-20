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
import termios
import threading
import time
import tty
from pathlib import Path

from dotenv import load_dotenv
from eth_account import Account

SPEND_AMOUNT_WEI = 500_000_000_000_000_000  # 0.5 IMX
TX_COST_WEI = 500_000_000_000_000  # 0.0005 IMX
BULK_MAX_FEE = 11_000_000_000  # 11 Gwei
BULK_PRIORITY_FEE = 10_000_000_000  # 10 Gwei


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


def deploy_batch(rpc: str, private_key: str, storageManager: str, batch_size: int) -> str:
    result = subprocess.run(
        [
            "cast", "send",
            "--rpc-url", rpc,
            "--private-key", private_key,
            "--priority-gas-price", "10000000000",
            "--gas-price", "10000000100",
            storageManager,
            "deploy(uint256)",
            str(batch_size),
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


def cmd_storage_test_init_part1(batch_size: int) -> None:
    private_key, rpc, storageManager = load_config()

    if not private_key:
        print("Error: PRIVATE_KEY not set in .env", file=sys.stderr)
        sys.exit(1)
    if not storageManager:
        print("Error: STORAGE4MANAGER not set in .env", file=sys.stderr)
        sys.exit(1)

    print(f"RPC:              {rpc}")
    print(f"Storage4Manager:  {storageManager}")
    print(f"Batch size:       {batch_size}")
    print()

    print(f"Calling deploy({batch_size}) ...", end=" ", flush=True)
    try:
        tx = deploy_batch(rpc, private_key, storageManager, batch_size)
        print(f"ok  {tx}")
    except RuntimeError as e:
        print("FAILED")
        print(f"  Error: {e}", file=sys.stderr)
        sys.exit(1)


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


def get_home_address(private_key: str) -> str:
    return Account.from_key(private_key).address


def new_account() -> tuple[str, str]:
    acct = Account.create()
    return "0x" + acct.key.hex(), acct.address


def get_balance_wei(rpc: str, address: str) -> int:
    result = subprocess.run(
        ["cast", "balance", "--rpc-url", rpc, address],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())
    return int(result.stdout.strip())


def transfer_imx(rpc: str, private_key: str, to: str, amount_wei: int) -> str:
    result = subprocess.run(
        [
            "cast", "send",
            "--rpc-url", rpc,
            "--private-key", private_key,
            "--gas-price", str(BULK_MAX_FEE),
            "--priority-gas-price", str(BULK_PRIORITY_FEE),
            "--value", str(amount_wei),
            to,
        ],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())
    for line in result.stdout.splitlines():
        if line.startswith("transactionHash"):
            return line.split()[-1]
    return result.stdout.strip()


def block_explorer_url(rpc: str, tx_hash: str) -> str:
    if "testnet" in rpc:
        return f"https://explorer.testnet.immutable.com/tx/{tx_hash}"
    return f"https://explorer.immutable.com/tx/{tx_hash}"


def read_key(prompt: str, valid: set[str]) -> str:
    sys.stdout.write(prompt)
    sys.stdout.flush()
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        while True:
            ch = sys.stdin.read(1).upper()
            if ch in valid:
                sys.stdout.write(ch + "\n")
                sys.stdout.flush()
                return ch
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)


def _with_retry(fn, *args, max_retries: int = 4, base_delay: float = 2.0):
    for attempt in range(max_retries + 1):
        try:
            return fn(*args)
        except RuntimeError as e:
            if attempt == max_retries or "429" not in str(e):
                raise
            time.sleep(base_delay * (2 ** attempt))


def cmd_bulk_store_cold(scale: int, iterations: int, val: int) -> None:
    private_key, rpc, storage_manager = load_config()

    if not private_key:
        print("Error: PRIVATE_KEY not set in .env", file=sys.stderr)
        sys.exit(1)
    if not storage_manager:
        print("Error: STORAGE4MANAGER not set in .env", file=sys.stderr)
        sys.exit(1)

    home_addr = get_home_address(private_key)
    balance_wei = get_balance_wei(rpc, home_addr)
    total_spend_wei = scale * SPEND_AMOUNT_WEI

    print(f"Home account:     {home_addr}")
    print(f"Balance:          {balance_wei / 1e18:.6f} IMX")
    print(f"Amount to spend:  {total_spend_wei / 1e18:.6f} IMX  ({scale} × {SPEND_AMOUNT_WEI / 1e18} IMX)")
    print()

    if balance_wei < total_spend_wei:
        print(
            f"Error: insufficient balance. Need {total_spend_wei / 1e18:.6f} IMX, "
            f"have {balance_wei / 1e18:.6f} IMX.",
            file=sys.stderr,
        )
        sys.exit(1)

    confirm = read_key("Proceed? [Y/N]: ", {"Y", "N"})
    if confirm != "Y":
        print("Aborted.")
        sys.exit(0)

    print()
    accounts = [new_account() for _ in range(scale)]
    print("Generated Accounts:")
    for pk, addr in accounts:
        print(f"  {addr}  {pk}")
    print()

    print("Funding generated accounts...")
    for pk, addr in accounts:
        print(f"  → {addr} ...", end=" ", flush=True)
        try:
            tx = _with_retry(transfer_imx, rpc, private_key, addr, SPEND_AMOUNT_WEI)
            print(f"ok  {tx}")
        except RuntimeError as e:
            print("FAILED")
            print(f"     {e}", file=sys.stderr)
            sys.exit(1)
    print()

    action = read_key("Ready. Press Y to start, S to skip, N to exit: ", {"Y", "S", "N"})
    print()

    if action == "N":
        print("Exiting.")
        sys.exit(0)

    results: list[tuple[str | None, str | None]] = [None] * scale

    if action == "Y":
        print(f"Submitting {scale} storeCold transactions in parallel...")

        def worker(idx: int, pk: str) -> None:
            try:
                tx = _with_retry(store_cold, rpc, pk, storage_manager, iterations, val + idx)
                results[idx] = (tx, None)
            except RuntimeError as e:
                results[idx] = (None, str(e))

        threads = [threading.Thread(target=worker, args=(i, accounts[i][0])) for i in range(scale)]
        for i, t in enumerate(threads):
            if i > 0:
                time.sleep(2)
            print(f"\r  Launching thread {i + 1} of {scale}...", end="", flush=True)
            t.start()
        print(f"\r  All {scale} threads launched.   ")
        for t in threads:
            t.join()

        print()
        print("Results:")
        for i, result in enumerate(results):
            _, addr = accounts[i]
            tx, err = result
            if tx:
                print(f"  [{i}] ok   {addr}")
                print(f"       {tx}")
                print(f"       {block_explorer_url(rpc, tx)}")
            else:
                print(f"  [{i}] FAIL {addr}")
                print(f"       {err}", file=sys.stderr)
        print()

    print("Pausing 30 seconds before returning funds...")
    for remaining in range(30, 0, -1):
        print(f"\r  {remaining:2d}s remaining...", end="", flush=True)
        time.sleep(1)
    print("\r  Done.              ")
    print()

    print("Returning remaining funds to home account...")
    for pk, addr in accounts:
        try:
            bal = get_balance_wei(rpc, addr)
            if bal <= TX_COST_WEI:
                print(f"  {addr}: balance too low ({bal} wei), skipping")
                continue
            return_amount = bal - TX_COST_WEI
            print(f"  ← {addr}  {return_amount / 1e18:.6f} IMX ...", end=" ", flush=True)
            tx = _with_retry(transfer_imx, rpc, pk, home_addr, return_amount)
            print(f"ok  {tx}")
        except RuntimeError as e:
            print(f"FAILED: {e}", file=sys.stderr)
    print()
    print("Done.")


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

    part1 = subparsers.add_parser(
        "storageTestInitPart1",
        help="Call deploy(uint256) on the Storage4Manager contract",
    )
    part1.add_argument("--batch-size", type=int, required=True, help="Batch size to pass to deploy()")

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

    bulk = subparsers.add_parser(
        "bulkStoreCold",
        help="Fund temporary accounts and call storeCold() from each in parallel",
    )
    bulk.add_argument("--scale", type=int, required=True, help="Number of parallel accounts/threads")
    bulk.add_argument("--iterations", type=int, required=True, help="Value for _iteration in each storeCold call")
    bulk.add_argument("--val", type=int, required=True, help="Base value for _val (each thread adds its index as offset)")

    args = parser.parse_args()

    if args.command == "storageTestInitPart1":
        cmd_storage_test_init_part1(args.batch_size)
    elif args.command == "storageTestInitPart2":
        cmd_storage_test_init_part2(args.offset, args.iterations)
    elif args.command == "storeCold":
        cmd_store_cold(args.iteration, args.val)
    elif args.command == "bulkStoreCold":
        cmd_bulk_store_cold(args.scale, args.iterations, args.val)


if __name__ == "__main__":
    main()
