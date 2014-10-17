nat(0).
nat(N):-nat(N1),N is N1+1.

camino(E,E, C,C).
camino(EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal):-
	unPaso(EstadoActual,EstSiguiente),
	\+member(EstSiguiente,CaminoHastaAhora),
	camino(EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal).

solucionOptima:-
	nat(N),
	camino( [b1,3,3,0,0], [b2,0,0,3,3], [b1,3,3,0,0], C),
	length(C,N),!,
	write(C).

% Passen de b1 a b2
unPaso( [b1,M1,C1,M2,C2], [b2,MF1,CF1,MF2,CF2] ):-
	passen(M,C),

	MF1 is M1-M,
	CF1 is C1-C,
	comprova(MF1,CF1),

	MF2 is M2+M,
	CF2 is C2+C,
	comprova(MF2,CF2).

% Passen de b2 a b1
unPaso( [b2,M1,C1,M2,C2], [b1,MF1,CF1,MF2,CF2] ):-
	passen(M,C),

	MF1 is M1+M,
	CF1 is C1+C,
	comprova(MF1,CF1),

	MF2 is M2-M,
	CF2 is C2-C,
	comprova(MF2,CF2).


passen(M,C):- member([M,C], [ [0,1], [0,2], [1,0], [1,1], [2,0] ] ).

% Vigilem que compleixin les normes
comprova(M,C):- 
	M>=0, M=<3, C>=0, C=<3,
	nomengen(M, C),
        M1 is 3-M,  C1 is 3-C,
	nomengen(M1,C1).

nomengen(0,_).
nomengen(M,C):- M >= C.


