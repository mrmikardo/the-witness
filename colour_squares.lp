connected(Y) :- edge(X, Y), connected(X).
connected(0).

0{ edge(X, Y) } :-
    vertex(X),
    vertex(Y),
    {|X - Y| == 1; |X - Y| == gridsize} = 1,
    not edge(Y, X),
    connected(X).

% symmetry-breaker for edge/2.
Y1 == Y2 :- edge(X1, Y1), edge(X2, Y2), X1 == X2.

% achieved: break crossing from "left edge" of grid
% to "right edge" of grid e.g. edge(4,3) or edge(3,4).
:- edge(X, Y), X \ gridsize == 0, X - Y == 1.
:- edge(X, Y), Y \ gridsize == 0, Y - X == 1.

% achieved: a valid answer set must terminate at the maximum vertex.
:- not connected(maxvertex).
:- edge(maxvertex, Y).

% achieved: 2 square are separate if they are adjacent and an edge
% connects the adjacent vertices.
separate(ID1, ID2) :- 1{edge(V1,V2); edge(V2,V1)},
                      adjacent(ID1,ID2,V1,V2).

% 2 squares ID1, ID2 are adjacent if they share ID1's top
% edge or ID1's right edge (ID2's bottom and left edge, respectively).
adjacent(ID1, ID2, V1_2, V1_3) :- square(ID1,V1_1,V1_2,V1_3,V1_4,_),
                                  square(ID2,V2_1,V2_2,V2_3,V2_4,_),
                                  V1_2 == V2_1,
                                  V1_3 == V2_4,
                                  ID1 != ID2.
adjacent(ID1, ID2, V1_3, V1_4) :- V1_3 == V2_2,
                                  V1_4 == V2_1,
                                  square(ID1,V1_1,V1_2,V1_3,V1_4,_),
                                  square(ID2,V2_1,V2_2,V2_3,V2_4,_),
                                  ID1 != ID2.

% achieved: 2 square are in the same region of the grid
% if they are adjacent and not separated by an edge.
same_region(ID1, ID2) :- adjacent(ID1,ID2,_,_), not separate(ID1, ID2).
same_region(ID1, ID2) :- same_region(ID1,ID3), same_region(ID3,ID2).

C1 == C2:- same_region(ID1, ID2),
           square(ID1,_,_,_,_,C1),
           square(ID2,_,_,_,_,C2).
