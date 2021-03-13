% achieved: a node is a tuple (x, y) of coordinates.
node(1,1). node(1,2). node(2,1). node(2,2).

% achieved: a node is connected if there is an edge leading
% to it.
connected((X2, Y2)) :- edge((X1, Y1), (X2, Y2)), connected((X1, Y1)).
connected((1,1)).

% achieved: an edge exists between 2 nodes where *either*
% the x-coordinate or the y-coordinate of the terminating
% node has a distance of 1 from the starting node.
edge((X1,Y1), (X2, Y2)) :-
    node(X1, Y1),
    node(X2, Y2),
    {|X2-X1| == 1; |Y2-Y1| == 1} = 1,
    not edge((X2, Y2), (X1, Y1)),
    connected((X1,Y1)).

% achieved: each node can be the starting point for at most
% 1 edge.
{ node(X1, Y1): edge((X1, Y1), (X2, Y2))} 1 :- node(X2, Y2).

#show edge/2.
%#show connected/1.
