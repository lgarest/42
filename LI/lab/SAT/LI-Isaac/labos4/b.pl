datosEjemplo( [[1,2,6],[1,6,7],[2,3,8],[6,7,9],[6,8,9],[1,2,4],[3,5,6],[3,5,7],
[5,6,8],[1,6,8],[4,7,9],[4,6,9],[1,4,6],[3,6,9],[2,3,5],[1,4,5],
[1,6,7],[6,7,8],[1,2,4],[1,5,7],[2,5,6],[2,3,5],[5,7,9],[1,6,8]] ).

% Aquestes son les tres primeres solucions que troba el programa
% totes amb un total de 13 xerrades en els 3 grups
% Sol = [[1, 2, 6, 7], [1, 5, 8, 9], [3, 4, 5, 6, 8]] ;
% Sol = [[1, 2, 6, 7], [1, 5, 8, 9], [3, 4, 5, 6, 9]] ;
% Sol = [[1, 3, 6, 7], [2, 5, 6, 9], [4, 5, 6, 7, 8]] .


% main
solucionOptima(L2):- 
	datosEjemplo(L),
	genera(L2),
	comprova(L,L2).


% mira totes les combinacions de xerrades que es poden fer
% començant amb un total de com a minim 3 xerrades i anar pujant (maxim 27)
% com que comença des de 3 i puja gradualment, la primera solucio que trobi
% sera el nombre minim de xerrades que s_han de fer 
genera([L1,L2,L3]):-
	between(3,27,N),
	between(1,9,N1),
	between(1,9,N2),
	N1 =< N2,
	between(1,9,N3),
	N2 =< N3,
	NF is N1+N2+N3,
	NF == N,
	combina(N1,[1,2,3,4,5,6,7,8,9],L1),
	combina(N2,[1,2,3,4,5,6,7,8,9],L2),
	combina(N3,[1,2,3,4,5,6,7,8,9],L3).


% combina(E,L,S)
% genera una subllista S de L amb E elements
combina(0,_,[]).
combina(E,L,[X|Xs]):-
	tros(X,L,R), E1 is E-1, combina(E1,R,Xs).

tros(X,[X|L],L).
tros(X,[_|L],R):- tros(X,L,R).


% comprova(C,S)
% comprova que la combinacio de xerrades llargues S
% sigui solucio de C (datosEjemplo en el nostre cas)
comprova([],_).
comprova([[X1,X2,X3]|L1],[S1,S2,S3]):-
						comprova(L1,[S1,S2,S3]),
						permutation([X1,X2,X3],[Y1,Y2,Y3]),
						member(Y1,S1),member(Y2,S2),member(Y3,S3),!.