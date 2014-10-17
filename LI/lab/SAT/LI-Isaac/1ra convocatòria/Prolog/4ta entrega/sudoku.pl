:- use_module(library(clpfd)).

sudoku(L):- sudoku2(L), forall(member(N,L), (write(N),nl)), !.


% Per a cada casella del sudoku que ens vingui plena per defecte,
% afegim el corresponent filled(I,J,K) a la llista, tal com s_indica a l_enunciat
plens(L):- L = [filled(1,1,9),
				filled(2,1,8),
				filled(3,7,4)].


% El primer parametre ha de ser una llista de totes les variables
% El segon parametre ha de ser la llista de caselles plenes
% Anem recorrent els "filleds" i donant el valor K a les variables 
% corresponents a la fila i columna indicats
omple(V,[X]):-
	omple2(V,X).
omple(V,[X|L]):-
	omple2(V,X),
	omple(V,L).


% Sigui V la llista de variables i F un "filled",
% la variable corresopnent a la fila I i columna J te el valor K
omple2(V,F):-
	F = filled(I,J,K),
	I1 is I-1, J1 is J-1,
	N is I1*9+J1,
	num2var(V,N,X),
	X = K.


% A partir de la llista de variables i un valor N, troba
% la variable Var corresponent
num2var([X|_],0,X).
num2var([_|L],N,Var):-
	N1 is N-1,
	num2var(L,N1,Var).


% Resolucio del sudoku fent un all_different per a cada 
% conjunt de variables que han de ser diferents
sudoku2([[A1,A2,A3,A4,A5,A6,A7,A8,A9],
		[B1,B2,B3,B4,B5,B6,B7,B8,B9],
		[C1,C2,C3,C4,C5,C6,C7,C8,C9],
		[D1,D2,D3,D4,D5,D6,D7,D8,D9],
		[E1,E2,E3,E4,E5,E6,E7,E8,E9],
		[F1,F2,F3,F4,F5,F6,F7,F8,F9],
		[G1,G2,G3,G4,G5,G6,G7,G8,G9],
		[H1,H2,H3,H4,H5,H6,H7,H8,H9],
		[I1,I2,I3,I4,I5,I6,I7,I8,I9]]):-


		V = 
	   [A1,A2,A3,A4,A5,A6,A7,A8,A9,
		B1,B2,B3,B4,B5,B6,B7,B8,B9,
		C1,C2,C3,C4,C5,C6,C7,C8,C9,
		D1,D2,D3,D4,D5,D6,D7,D8,D9,
		E1,E2,E3,E4,E5,E6,E7,E8,E9,
		F1,F2,F3,F4,F5,F6,F7,F8,F9,
		G1,G2,G3,G4,G5,G6,G7,G8,G9,
		H1,H2,H3,H4,H5,H6,H7,H8,H9,
		I1,I2,I3,I4,I5,I6,I7,I8,I9],

		V ins 1..9,

		plens(P),
		omple(V,P),

		% Columnes
		all_different([A1,A2,A3,A4,A5,A6,A7,A8,A9]),
		all_different([B1,B2,B3,B4,B5,B6,B7,B8,B9]),
		all_different([C1,C2,C3,C4,C5,C6,C7,C8,C9]),
		all_different([D1,D2,D3,D4,D5,D6,D7,D8,D9]),
		all_different([E1,E2,E3,E4,E5,E6,E7,E8,E9]),
		all_different([F1,F2,F3,F4,F5,F6,F7,F8,F9]),
		all_different([G1,G2,G3,G4,G5,G6,G7,G8,G9]),
		all_different([H1,H2,H3,H4,H5,H6,H7,H8,H9]),
		all_different([I1,I2,I3,I4,I5,I6,I7,I8,I9]),


		% Files
		all_different([A1,B1,C1,D1,E1,F1,G1,H1,I1]),
		all_different([A2,B2,C2,D2,E2,F2,G2,H2,I2]),
		all_different([A3,B3,C3,D3,E3,F3,G3,H3,I3]),
		all_different([A4,B4,C4,D4,E4,F4,G4,H4,I4]),
		all_different([A5,B5,C5,D5,E5,F5,G5,H5,I5]),
		all_different([A6,B6,C6,D6,E6,F6,G6,H6,I6]),
		all_different([A7,B7,C7,D7,E7,F7,G7,H7,I7]),
		all_different([A8,B8,C8,D8,E8,F8,G8,H8,I8]),
		all_different([A9,B9,C9,D9,E9,F9,G9,H9,I9]),

		% Quadres
		all_different([A1,B1,C1,A2,B2,C2,A3,B3,C3]),
		all_different([A4,B4,C4,A5,B5,C5,A6,B6,C6]),
		all_different([A7,B7,C7,A8,B8,C8,A9,B9,C9]),
		all_different([D1,E1,F1,D2,E2,F2,D3,E3,F3]),
		all_different([D4,E4,F4,D5,E5,F5,D6,E6,F6]),
		all_different([D7,E7,F7,D8,E8,F8,D9,E9,F9]),
		all_different([G1,H1,I1,G2,H2,I2,G3,H3,I3]),
		all_different([G4,H4,I4,G5,H5,I5,G6,H6,I6]),
		all_different([G7,H7,I7,G8,H8,I8,G9,H9,I9]),

		label(V), !.