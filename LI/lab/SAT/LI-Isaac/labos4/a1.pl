nat(0).
nat(N):-nat(N1),N is N1+1.

camino(E,E, C,C).
camino(EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal):-
	unPaso(EstadoActual,EstSiguiente),
	\+member(EstSiguiente,CaminoHastaAhora),
	camino(EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal).

solucionOptima:-
	nat(N),
	camino([0,0],[0,4],[[0,0]],C),
	length(C,N), !,	
	write(C).

% Passar del primer al segon
unPaso([N,M],[N1,M1]):- 
	N > 0,
	E is M+N,
	min(8,E,MIN),
	M1 is MIN,
	E2 is N-(8-M),
	max(0,E2,MAX),
	N1 is MAX.

% Passar del segon al primer
unPaso([N,M],[N1,M1]):- 
	M > 0,
	E is M+N,
	min(5,E,MIN),
	N1 is MIN,
	E2 is N-(5-M),
	max(0,E2,MAX),
	M1 is MAX.

% Buidar el primer
unPaso([_,M],[0,M]).

% Buidar el segon
unPaso([N,_],[N,0]).

% Omplir el primer
unPaso([_,M],[5,M]).

% Omplir el segon
unPaso([N,_],[N,8]).

% Agafar el minim
min(A,B,B):- A >= B,!.
min(A,_,A).

% Agafar el maxim
max(A,B,A):- A >= B,!.
max(_,B,B).

