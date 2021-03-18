vertex(0..16).

connected(Y) :- edge(X, Y), connected(X).
connected(0).

0{ edge(X, Y) } :-
    vertex(X),
    vertex(Y),
    {|X - Y| == 1; |X - Y| == 3} = 1,
    not edge(Y, X),
    connected(X).

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
square(0,3,4,6,7, black). square(1,4,7,5,8, black).
%square(1,1,4,2,5, black).

% auxiliary predicate, used in definition of separate/2.
in(ID, V1, V2) :- 1{
                      square(ID,V1,_,_,_,_);
                      square(ID,_,V1,_,_,_);
                      square(ID,_,_,V1,_,_);
                      square(ID,_,_,_,V1,_)
                  },
                  1{
                      square(ID,V2,_,_,_,_);
                      square(ID,_,V2,_,_,_);
                      square(ID,_,_,V2,_,_);
                      square(ID,_,_,_,V2,_)
                  },
                  vertex(V1),
                  vertex(V2),
                  V1 != V2,
                  square(ID,_,_,_,_,_).

% achieved: 2 squares ID1, ID2 are separated by any edge that
% they share.
separate(ID1, ID2) :- 1{edge(V1,V2); edge(V2,V1)},
                      ID1 != ID2,
                      in(ID1,V1,V2),
                      in(ID2,V1,V2).

adjacent(ID1, ID2) :- not separate(ID1, ID2),
                      square(ID1,_,_,_,_,_),
                      square(ID2,_,_,_,_,_).

% TODO
same_region(ID1, ID2) :- adjacent(ID1, ID2), not separate(ID1, ID2), ID1 != ID2.
same_region(ID1, ID3) :- same_region(ID1, ID2), same_region(ID2, ID3), ID1 != ID3.

%#show square/6.
%#show separate/2.
%#show same_region/2.
%#show edge/2.
%#show connected/1.
#show vertex/1.
#show max/1.
