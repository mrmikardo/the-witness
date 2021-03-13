node(1). node(2). node(3). node(4).

connected(Y) :- edge(X, Y), connected(X).
connected(1).

edge(X, Y) :- node(X), node(Y), |X - Y| == 1, not edge(Y, X), connected(X).

#show edge/2.
#show connected/1.
