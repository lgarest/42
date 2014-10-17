%suma_ants(L)

suma_ants([X|L]):- sumals(L,X).

sumals([],_).
sumals([X|L],S):- S1 is X+S, sumals(L,S1), S == X, !.
