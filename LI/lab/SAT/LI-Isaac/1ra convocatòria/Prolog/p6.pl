%ex3
%pescalar(L1,L2,P)
pescalar([],[],0):- !.
pescalar([_],[],_):- fail.
pescalar([],[_],_):- fail.
pescalar([X|XS],[Y|YS],P):- pescalar(XS,YS,P1), P is X*Y+P1, !.


%ex4
%unio(L1,L2,L3)
unio(X,[],X):-!.
unio([],Y,Y):-!.
unio([X|XS],[Y|YS],[X,Y|L]):- unio(XS,YS,L),!.

treuRepes([],[]):-!.
treuRepes([X|XS],[X|L3]):- treuRepes2(X,XS,L2), treuRepes(L2,L3).

treuRepes2(_,[],[]):-!.
treuRepes2(X,[X|YS],L):- treuRepes2(X,YS,L).
treuRepes2(X,[Y|YS],[Y|L]):- treuRepes2(X,YS,L).


%esta_ordenada
esta_ordenada([]):- write('yes'),!.
esta_ordenada([_]):- write('yes'),!.
esta_ordenada([X,Y]):- X < Y, write('yes'),!.
esta_ordenada([X,Y|XS]):- X =< Y, esta_ordenada([Y|XS]),!.
esta_ordenada([X,Y|_]):- X > Y, write('no'),fail.