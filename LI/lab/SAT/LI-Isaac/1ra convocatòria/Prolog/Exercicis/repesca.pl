%ex2
prod([X],X).
prod([X|L],P):- prod(L,P1), P is P1*X.

%---------------------------------------

%ex4

interseccio([X|L1],L2,[X|L]):- member(X,L2), interseccio(L1,L2,L).
interseccio([X|L1],L2,L):- \+ member(X,L2), interseccio(L1,L2,L).
interseccio([],_,[]).

unio(L1,L2,L):- append(L1,L2,L).


%---------------------------------------

%ex8

suma_demas(L):- 
	size(L,S), between(0,S,N), N < S, recorrer(L,N,K), suma(L,F), F1 is F-K, F1 == K.

% K es el n-essim element de la llista
recorrer([X|_],0,X).
recorrer([_|L],N,K):- N1 is N-1, recorrer(L,N1,K).

%
size([_],1).
size([_|L],S):- size(L,S1), S is S1+1.

% suma els elements d.una llista
suma([X],X).
suma([X|L],K):- suma(L,K1), K is K1+X.


%---------------------------------------

%ex7
% Escribe un predicado Prolog dados(P,N,L) que signifique “la lista
% L expresa una manera de sumar P puntos lanzando N dados”. Por ejemplo: si P es
% 5 i N es 2, una solucion seŕıa [1,4]. (Ńotese que la longitud de L es N). Tanto
% P como N vienen instanciados. El predicado debe ser capaz de generar todas las
% soluciones posibles.

dados(P,N,L):- pdaus(P,LD), suma(LD,F), F == N, L = LD.

% L es una llista de P valors entre 1 i 6
pdaus(1,[N]):- between(1,6,N).
pdaus(P,L):- P1 is P-1, P1 > 0, pdaus(P1,L2), between(1,6,D), append([D],L2,L3), L = L3.


%---------------------------------------

%ex12

ordenacio(L1,L3):- permutation(L1,L3), esta_ordenada(L3), !.

esta_ordenada([X|L]):- major(X,L), !.

major(N,[X]):- X > N.
major(N,[X|L]):- X > N, major(X,L).


%---------------------------------------

%ex18

palindroms(L):- permutation(L,L2), capicua(L2), write(L2).

capicua(L):- capgira(L,L2), comprova(L,L2).

comprova([X],[Y]):- X == Y.
comprova([X|L],[Y|L2]):- X == Y, comprova(L,L2), !.

capgira([X],[X]).
capgira([X|L],L2):- capgira(L,L3), append(L3,[X],L2), !.


%---------------------------------------

%ex

%simplifica(D,D1):- 
simplifica(X+0,X).
simplifica(0+X,X).
simplifica(X-0,X).
simplifica(0- X,X).
simplifica(X*1,X).
simplifica(1*X,X).
simplifica(0*_,0).
simplifica(_*0,0).
simplifica(A+B,D3):- simplifica(A,D1), simplifica(B,D2), simplifica(D1+D2, D3).
simplifica(A-B,D3):- simplifica(A,D1), simplifica(B,D2), simplifica(D1-D2, D3).
simplifica(A*B,D3):- simplifica(A,D1), simplifica(B,D2), simplifica(D1*D2, D3).






