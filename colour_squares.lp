vertex(0..16).

connected(Y) :- edge(X, Y), connected(X).
connected(0).

0{ edge(X, Y) } :-
    vertex(X),
    vertex(Y),
    {|X - Y| == 1; |X - Y| == 3} = 1,
    not edge(Y, X),
    connected(X).

% symmetry-breaker for edge/2.
Y1 == Y2 :- edge(X1, Y1), edge(X2, Y2), X1 == X2.

% achieved: break crossing from "left edge" of grid
% to "right edge" of grid e.g. edge(4,3) or edge(3,4).
:- edge(X, Y), X \ 3 == 0, X - Y == 1.
:- edge(X, Y), Y \ 3 == 0, Y - X == 1.

% achieved: a valid answer set must terminate at vertex 8.
:- not connected(8).
:- edge(8, Y).

% a square/6 is defined by its ID, 4 vertices, and a colour.
% the ID is the first member of the tuple.
% vertices are numbered clockwise, from bottom-left
%
% e.g. square(1,0,3,4,1,black) denotes a black square
% with an ID of 1, bounded by the vertices 0-3-4-1.
%
% this ordering of vertices is relied upon by adjacent/2.
square(1,0,3,4,1, black). square(2,1,4,5,2, white).
square(3,3,6,7,4, white). square(4,4,7,8,5, white).

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

% TODO
same_region(ID1, ID2) :- not separate(ID1, ID2),
                         ID1 != ID2,
                         square(ID1,_,_,_,_,_),
                         square(ID2,_,_,_,_,_).
same_region(ID1, ID3) :- adjacent(ID1, ID2),
                         adjacent(ID2, ID3),
                         not separate(ID1, ID2),
                         not separate(ID2, ID3).

%#show square/6.
%#show separate/2.
#show same_region/2.
#show edge/2.
%#show connected/1.
#show adjacent/2.

