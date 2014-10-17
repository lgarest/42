nat(0).
nat(N):- nat(N1), N is N1+1.

camino(E,E, C,C).
camino(EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal):-
	unPaso(EstadoActual,EstSiguiente),
	\+member(EstSiguiente,CaminoHastaAhora),
	camino(EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal).

solucionOptima:-
	nat(N),
	camino([p1,[1,2,5,8],[],0] , [p2,[],[1,2,5,8],T] , [p1,[1,2,5,8],[],0] ,C),
	T == N,
	write(C).


% En passen dos.
% Sempre n'han de passar dos des d'aquesta banda, en qualsevol cas.
% T2 conte el temps acumulat.
unPaso([ p1,L1,L2,T1 ] , [ p2,LF1,LF2,T2 ]):-
	length(L1,M),
	M > 1,
	dosAdos(L1,R),
	member(N,R),
	esborra(L1,N,LF1),
	append(L2,N,LF21),
	sort(LF21,LF2),
	max(N,K),
	T2 is T1+K.
	
% En torna un. 
% Crec que si en tornessin dos sempre hi hauria penalitzacio de temps,
% per tant no ens fa falta passar-ne mes d_un.
% T2 conte el temps acumulat.
unPaso([ p2,L1,L2,T1 ] , [ p1,LF1,LF2,T2 ]):-
	length(L1,M),
	M \== 0,
	member(N,L2),
	esborra(L2,[N],LF2),
	append(L1,[N],LF11),
	sort(LF11,LF1),
	T2 is T1+N.


% dosAdos(L,F): F es una llista que conte conjunts dels elements de L
% agrupats dos a dos.	
dosAdos([_],F):- F = [].
dosAdos([X|L],F):- dosAdos(L,F1), dosAdos2(X,L,F2), append(F1,F2,F).

dosAdos2(X,[Y],F):- F = [[X,Y]].
dosAdos2(X,[Y|L],F):- dosAdos2(X,L,F1), F2 = [[X,Y]], append(F1,F2,F).


% esborra(L,D,R): R es una llista amb els elements de D que estan a L 
% esborrats (nomes n_eliminaria un si n_hi hagues de repetits).
esborra(L,D,R) :-
	select(E,L,L1),
	select(E,D,D1), !,
	esborra(L1,D1,R).
esborra(L,_,L):- !.


% max([X,Y],M): M es l_element mes gran (X o Y)
max([X,Y],M):- X >= Y, M is X, !.
max([_,Y],Y).
