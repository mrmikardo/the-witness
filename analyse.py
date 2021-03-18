import os
import sys
from pathlib import Path

from witness.colour_squares_test import SearchResult, _parse_search_result


CLINGO_OUTPUT_DIR = Path(__file__).parents[0]


def main():
    try:
        filename = sys.argv[1]
    except IndexError:
        print("Usage: python analyse.py <CLINGO OUTUT FILE>.")
        sys.exit(1)

    search_results = []
    with open(os.path.join(CLINGO_OUTPUT_DIR, filename)) as f:
        lines = f.readlines()
        for i, line in enumerate(lines):
            if line.startswith("Answer:"):
                # 8 characters = "Answer: ", grab the result set index (ix)
                ix = int(line[8:])
                sr = _parse_search_result(lines[i + 1], ix)
                print(
                    f"SearchResult {sr.result_number}. Total atoms: {sr.atoms_count}."
                )
                print(f"Distinct predicates: {sr.predicate_count_total}.")
                print(f"Predicates by count: {sr.predicate_counts}")
                search_results.append(sr)


if __name__ == "__main__":
    main()
