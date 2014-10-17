%pescalar(L1,L2,P)

pescalar([L1],[L2],_):- longitud(L1) > longitud(L2), longitud(L1) < longitud(L2), !.
pescalar([],[],0).
pescalar([X|L1],[Y|L2],P):- pescalar(L1,L2,P1), P is P1+(X*Y).
