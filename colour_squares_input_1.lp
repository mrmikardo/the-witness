#const gridsize=4.
#const maxvertex=15.

vertex(0..maxvertex).

square(1,0,4,5,1,purple). square(2,1,5,6,2,purple). square(3,2,6,7,3,purple).
square(4,4,8,9,5,white). square(5,5,9,10,6,white). square(6,6,10,11,7,purple).
square(7,8,12,13,9,green). square(8,9,13,14,10,white). square(9,10,14,15,11,white).

#show edge/2.
%#show same_region/2.
