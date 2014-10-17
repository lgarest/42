%suma_demas(L)

suma_demas(L):- suma_tots(L,S1), comprova(L,S1).

suma_tots([X],X).
suma_tots([X|L],S):- suma_tots(L,S1), S is S1+X.

comprova([X|_],S1):- S is S1-X, S == X. 
comprova([_|L],S1):- comprova(L,S1).
