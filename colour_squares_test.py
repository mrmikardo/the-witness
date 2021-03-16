import os
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple

import pytest


CLINGO_OUTPUT_DIR = Path(__file__).parents[0] / "output"


# parse terms from atoms
term_re = re.compile(r"\(.+\)")
ix_re = re.compile(r"\sd+$")
edge_re = re.compile(r"(?:edge\()(\d+)(?:,)(\d+)")


class SearchResult:
    def __init__(self, ix: int, atoms: List[str]):
        self.result_number = ix
        self.atoms = atoms

    def __str__(self):
        return f"SearchResult {self.result_number}"

    @property
    def atoms_count(self) -> int:
        """ Returns a count of all the atoms (predicates). """
        return len(self.atoms)

    def get_predicate_count_total(self) -> int:
        """ Returns a count of different predicates. """
        pass

    def get_predicates_to_counts(self) -> Dict[str, int]:
        """ Returns a mapping from predicates to counts. """
        pass

    @property
    def edges(self) -> List[Tuple[int]]:
        """ Returns a list of all the edges, represented as tuples. """
        edges = []
        for atom in self.atoms:
            match = edge_re.match(atom)
            if match and len(match.groups()) == 2:
                edges.append((int(match.groups()[0]), int(match.groups()[1])))
        return edges


def _parse_search_result(sr, ix):
    # split line into atoms
    atoms = sr.split()
    parse = SearchResult(ix, atoms)
    return parse


@pytest.fixture
def clingo_output():
    search_results = []
    with open(os.path.join(CLINGO_OUTPUT_DIR, "output_1")) as f:
        lines = f.readlines()
        for i, line in enumerate(lines):
            if line.startswith("Answer:"):
                # 8 characters = "Answer: ", grab the result set index (ix)
                ix = int(line[8:])
                sr = _parse_search_result(lines[i + 1], ix)
                print(f"SearchResult {sr.result_number} with edges {sr.edges}")
                search_results.append(sr)
        return search_results


# for a 3x3 grid
ACCEPTABLE_EDGES = [
    (0, 1),
    (0, 3),
    (1, 0),
    (1, 2),
    (1, 4),
    (2, 1),
    (2, 5),
    (3, 0),
    (3, 4),
    (3, 6),
    (4, 3),
    (4, 1),
    (4, 5),
    (4, 7),
    (5, 4),
    (5, 2),
    (5, 8),
    (6, 3),
    (6, 7),
    (7, 6),
    (7, 4),
    (7, 8),
    (8, 7),
    (8, 5),
]


def test_edge_generation_correctness(clingo_output):
    """
    A search result is incorrect if it contains edges
    not from the set of incorrect edges, or if it contains
    duplicate edges, or if it contains symmetrical edges.
    """

    for sr in clingo_output:
        for edge in sr.edges:
            # test acceptable edges
            assert (
                edge in ACCEPTABLE_EDGES
            ), f"edge {edge} not in ACCEPTABLE_EDGES. Failing result was {sr}."
        # test no duplicate edges
        assert len(sr.edges) == len(
            set(sr.edges)
        ), f"SearchResult {sr} contains duplicate edges."
        # test no symmetrical edges
        sorted_edges = list(map(lambda tup: tuple(sorted(tup)), sr.edges))
        assert len(sorted_edges) == len(
            set(sorted_edges)
        ), f"SearchResult {sr} contains symmetrical edges."


def test_edge_generation_completeness():
    pass
