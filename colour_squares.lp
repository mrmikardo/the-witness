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

#show edge/2.
%#show connected/1.
