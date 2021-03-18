import os
import re
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple

import pytest


CLINGO_OUTPUT_DIR = Path(__file__).parents[1] / "output"


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

    @property
    def predicate_count_total(self) -> int:
        """ Returns a count of different predicates. """
        return len(set(self.atoms))

    def _get_predicate_names(self):
        """ Returns only the *names* of predicates (no terms). """
        predicate_names = []
        for atom in self.atoms:
            predicate_names.append(atom.split("(")[0])
        return predicate_names

    @property
    def predicate_counts(self) -> Dict[str, int]:
        """ Returns a mapping from predicates to counts. """
        predicate_counts = defaultdict(int)
        for pred in self._get_predicate_names():
            predicate_counts[pred] += 1
        return predicate_counts

    @property
    def edges(self) -> List[Tuple[int]]:
        """ Returns a list of all the edges, represented as tuples. """
        edges = []
        for atom in self.atoms:
            match = edge_re.match(atom)
            if match and len(match.groups()) == 2:
                edges.append((int(match.groups()[0]), int(match.groups()[1])))
        return edges

    @property
    def vertices(self) -> List[int]:
        """ Returns a list of all of the vertices. """
        vertices = []
        for edge in self.edges:
            vertices.append(edge[0])
            vertices.append(edge[1])
        return vertices


def _parse_search_result(sr, ix):
    # split line into atoms
    atoms = sr.split()
    parse = SearchResult(ix, atoms)
    return parse


@pytest.fixture
def clingo_output():
    search_results = []
    with open(os.path.join(CLINGO_OUTPUT_DIR, "output_5")) as f:
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


def test_edge_correctness(clingo_output):
    """
    A search result is incorrect if it contains edges
    not from the set of incorrect edges, or if it contains
    duplicate edges, or if it contains symmetrical edges.

    No vertex should be included more than once, and the
    result should have a single edge from the lowest-
    numbered edge, and a single edge to the highest-numbered
    edge.
    """

    for sr in clingo_output:
        for edge in sr.edges:
            # test acceptable edges
            assert (
                edge in ACCEPTABLE_EDGES
            ), f"edge {edge} not in ACCEPTABLE_EDGES. Failing result was {sr}."

            # test no two edges starting at the same vertex
            assert (
                len(list(filter(lambda e: e[0] == edge[0], sr.edges))) == 1
            ), f"SearchResult {sr} contains multiple edges starting at {edge[0]}!"

            # test no two edges ending at the same vertex
            assert (
                len(list(filter(lambda e: e[1] == edge[1], sr.edges))) == 1
            ), f"SearchResult {sr} contains multiple edges terminating at {edge[1]}!"

        # test no duplicate edges
        assert len(sr.edges) == len(
            set(sr.edges)
        ), f"SearchResult {sr} contains duplicate edges."

        # test no symmetrical edges
        sorted_edges = list(map(lambda tup: tuple(sorted(tup)), sr.edges))
        assert len(sorted_edges) == len(
            set(sorted_edges)
        ), f"SearchResult {sr} contains symmetrical edges."

        # test there is a single valid edge from vertex 0
        # there are only 2 possible valid edges from vertex 0:
        # (0,1) and (0,3).
        assert (0, 1) in sr.edges or (
            0,
            3,
        ) in sr.edges, f"SearchResult {sr} missing an edge from vertex 0."
        assert not (
            (0, 1) in sr.edges and (0, 3) in sr.edges
        ), f"SearchResult {sr} contains 2 edges from vertex 0!"

        # test there is a single edge which terminates at
        # the highest-numbered vertex in the set
        greatest_vertex = max(sr.vertices)
        assert (
            len(list(filter(lambda e: e[1] == greatest_vertex, sr.edges))) == 1
        ), f"SearchResult {sr} has no edge terminating at {greatest_vertex}."


def test_edge_completeness():
    pass
