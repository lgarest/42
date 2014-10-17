
% datosEjemplo(L,F): F serà el conjunt dels tres slots horaris de les xerrades.
datosEjemplo(L,F):- genera2(A), comprova(L,A,FINAL), F = FINAL, !.

% Genera tres llistes amb totes les diferents combinacions.
% Es una solucio altament ineficient, ja que repeteix una gran quantitat
% d'opcions permutades. Es a dir, per a nosaltres es el mateix
% [[1],[1],[2]]	que [[1],[2],[1]], per tant no caldria repetir-ho.
genera1([N1,N2,N3]):- 
	N = [1,2,3,4,5,6,7,8,9],
	num(M1), combina(M1,N,N1),
	num(M2), combina(M2,N,N2),
	num(M3), combina(M3,N,N3).


% Genera tres llistes amb forces combinacions.
% Es una solucio eficient pero no bona, ja que no te perque trobar 
% la millor opcio, tot i que les solucions trobades no seran molt dolentes
% (com a molt hi haura dues conferencies mes que a la solucio mes optima).
genera2([N1,N2,N3]):- 
	N = [1,2,3,4,5,6,7,8,9], num(M),
	combina(M,N,N1),
	combina(M,N,N2),
	combina(M,N,N3).

% La millor idea que se m_ha acudit no he estat capaç d_implementar-la,
% tot hi haver-m_hi trencat el cap forces hores.	

num(N):- member(N, [1,2,3,4,5,6,7,8,9] ).

% Ex: comprova(L1,LF):  
comprova([],_,_).
comprova([X|L1],L2,LF):- comprova(L1,L2,_), permutation(X,M), pertanyen(M,L2), LF = L2.

pertanyen([A,B,C],[L1,L2,L3]):- pertany(A,L1), pertany(B,L2), pertany(C,L3), !.

% pertany(X,L): X pertany o no a la llista L
pertany(X,[X|_]):- !.
pertany(X,[_|L]):- pertany(X,L).
	
% combina(K,L,C): C es una llista amb K elements diferents de la llista L 
combina(0,_,[]).
combina(K,L,[X|Xs]) :- K > 0,
   primer(X,L,R), K1 is K-1, combina(K1,R,Xs).
   
primer(X,[X|L],L).
primer(X,[_|L],R) :- primer(X,L,R).
