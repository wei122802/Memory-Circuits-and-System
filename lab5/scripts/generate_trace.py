#!/usr/bin/env python3
"""
Generate assignment trace files for Ramulator-like LoadStoreStallTrace format:

    LD/ST address stall_time type

Pattern:
    1. First generate a block of ST requests
    2. Then generate a block of LD requests

Address offset defaults to 128 bytes.
Stall time and type default to 0.

Examples:
    python3 generate_trace.py --pattern sequential --st-count 16 --ld-count 16 -o seq.trace
    python3 generate_trace.py --pattern random --st-count 16 --ld-count 16 --addr-space 4096 -o rand.trace
    python3 generate_trace.py --pattern both --st-count 16 --ld-count 16 --addr-space 4096 --out-prefix test
"""

import argparse
import random
from pathlib import Path
from typing import List


def gen_sequential_addrs(base_addr: int, count: int, offset: int) -> List[int]:
    """Generate sequential addresses: base, base+offset, base+2*offset, ..."""
    return [base_addr + i * offset for i in range(count)]


def gen_random_addrs(base_addr: int, count: int, offset: int, addr_space: int, rng: random.Random) -> List[int]:
    """
    Generate random aligned addresses.

    addr_space means the selectable byte range starting from base_addr.
    For offset=128 and addr_space=4096, candidates are:
        base_addr + 0*128, base_addr + 1*128, ..., base_addr + 31*128
    """
    if addr_space < offset:
        raise ValueError("addr_space must be >= offset")

    num_slots = addr_space // offset
    return [base_addr + rng.randrange(num_slots) * offset for _ in range(count)]


def write_trace(
    output_path: Path,
    st_addrs: List[int],
    ld_addrs: List[int],
    stall_time: int = 0,
    req_type: int = 0,
    hex_addr: bool = True,
) -> None:
    """Write trace in format: LD/ST address stall_time type."""
    with output_path.open("w", encoding="utf-8") as f:
        for addr in st_addrs:
            addr_str = hex(addr) if hex_addr else str(addr)
            f.write(f"ST {addr_str} {stall_time} {req_type}\n")

        for addr in ld_addrs:
            addr_str = hex(addr) if hex_addr else str(addr)
            f.write(f"LD {addr_str} {stall_time} {req_type}\n")


def generate_one_trace(args: argparse.Namespace, pattern: str, output_path: Path) -> None:
    rng = random.Random(args.seed)

    if pattern == "sequential":
        st_addrs = gen_sequential_addrs(args.st_base, args.st_count, args.offset)
        ld_addrs = gen_sequential_addrs(args.ld_base, args.ld_count, args.offset)
    elif pattern == "random":
        st_addrs = gen_random_addrs(args.st_base, args.st_count, args.offset, args.addr_space, rng)
        ld_addrs = gen_random_addrs(args.ld_base, args.ld_count, args.offset, args.addr_space, rng)
    else:
        raise ValueError(f"Unsupported pattern: {pattern}")

    write_trace(
        output_path=output_path,
        st_addrs=st_addrs,
        ld_addrs=ld_addrs,
        stall_time=args.stall_time,
        req_type=args.type,
        hex_addr=not args.decimal_addr,
    )

    print(f"Generated {output_path}")
    print(f"  pattern   : {pattern}")
    print(f"  ST count  : {args.st_count}")
    print(f"  LD count  : {args.ld_count}")
    print(f"  offset    : {args.offset}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate trace: LD/ST address stall_time type"
    )

    parser.add_argument(
        "--pattern",
        choices=["sequential", "random", "both"],
        default="sequential",
        help="Trace address pattern. Use 'both' to generate sequential and random traces.",
    )
    parser.add_argument("--st-count", type=int, default=16, help="Number of ST requests")
    parser.add_argument("--ld-count", type=int, default=16, help="Number of LD requests")
    parser.add_argument("--offset", type=int, default=128, help="Address offset/alignment in bytes")

    parser.add_argument("--st-base", type=lambda x: int(x, 0), default=0x00000000, help="Base address for ST")
    parser.add_argument("--ld-base", type=lambda x: int(x, 0), default=0x00010000, help="Base address for LD")

    parser.add_argument(
        "--addr-space",
        type=int,
        default=4096,
        help="Random address selectable range in bytes. Only used for random pattern.",
    )
    parser.add_argument("--seed", type=int, default=0, help="Random seed")
    parser.add_argument("--stall-time", type=int, default=0, help="stall_time field")
    parser.add_argument("--type", type=int, default=0, help="type field")
    parser.add_argument("--decimal-addr", action="store_true", help="Output addresses in decimal instead of hex")

    parser.add_argument("-o", "--output", default="trace.txt", help="Output trace file")
    parser.add_argument(
        "--out-prefix",
        default="trace",
        help="Output prefix when --pattern both is used",
    )

    return parser.parse_args()


def main() -> None:
    args = parse_args()

    if args.st_count < 0 or args.ld_count < 0:
        raise ValueError("st-count and ld-count must be non-negative")
    if args.offset <= 0:
        raise ValueError("offset must be positive")

    if args.pattern == "both":
        generate_one_trace(args, "sequential", Path(f"{args.out_prefix}_sequential.trace"))
        generate_one_trace(args, "random", Path(f"{args.out_prefix}_random.trace"))
    else:
        generate_one_trace(args, args.pattern, Path(args.output))


if __name__ == "__main__":
    main()
