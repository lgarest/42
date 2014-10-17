:- use_module(library(clpfd)).

assigna:- 
	% cada LX representa la llista de possibilitats (pc1,pc2..pc5) d_execucio de la tasca X
	L1 = [T11,T12,T13,T14,T15],
	L2 = [T21,T22,T23,T24,T25],
	L3 = [T31,T32,T33,T34,T35],
	L4 = [T41,T42,T43,T44,T45],
	L5 = [T51,T52,T53,T54,T55],
	L6 = [T61,T62,T63,T64,T65],
	L7 = [T71,T72,T73,T74,T75],
	L8 = [T81,T82,T83,T84,T85],
	L9 = [T91,T92,T93,T94,T95],
	L10 = [T101,T102,T103,T104,T105],
	L11 = [T111,T112,T113,T114,T115],
	L12 = [T121,T122,T123,T124,T125],
	L13 = [T131,T132,T133,T134,T135],
	L14 = [T141,T142,T143,T144,T145],

	% concatena totes les llistes (ens serveix pel labeling del final)
	concat([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14],C),

	% assignem a cada llista un 1 a una 'variable' (sera el PC on s_executa)
	% la resta de variables a 0 (perque cada tasca nomes s_assigna a un PC)
    global_cardinality(L1,[0-_,1-1]),
    global_cardinality(L2,[0-_,1-1]),
    global_cardinality(L3,[0-_,1-1]),
    global_cardinality(L4,[0-_,1-1]),
    global_cardinality(L5,[0-_,1-1]),
    global_cardinality(L6,[0-_,1-1]),
    global_cardinality(L7,[0-_,1-1]),
    global_cardinality(L8,[0-_,1-1]),
    global_cardinality(L9,[0-_,1-1]),
    global_cardinality(L10,[0-_,1-1]),
    global_cardinality(L11,[0-_,1-1]),
    global_cardinality(L12,[0-_,1-1]),
    global_cardinality(L13,[0-_,1-1]),
    global_cardinality(L14,[0-_,1-1]),
	
	% assignem a cada PC el temps que tardara a executar les tasques que te assignades
	PC1 #= T11*8+T21*6+T31*7+T41*5+T51*2+T61*3+T71*8+T81*6+T91*2+T101*6+T111*1+T121*2+T131*6+T141*4,
	PC2 #= T12*8+T22*6+T32*7+T42*5+T52*2+T62*3+T72*8+T82*6+T92*2+T102*6+T112*1+T122*2+T132*6+T142*4,
	PC3 #= T13*8+T23*6+T33*7+T43*5+T53*2+T63*3+T73*8+T83*6+T93*2+T103*6+T113*1+T123*2+T133*6+T143*4,
	PC4 #= T14*8+T24*6+T34*7+T44*5+T54*2+T64*3+T74*8+T84*6+T94*2+T104*6+T114*1+T124*2+T134*6+T144*4,
	PC5 #= T15*8+T25*6+T35*7+T45*5+T55*2+T65*3+T75*8+T85*6+T95*2+T105*6+T115*1+T125*2+T135*6+T145*4,

	% PC que tarda mes a executar les tasques
	maxim([PC1,PC2,PC3,PC4,PC5],MAX),

	% minimitzem el valor maxim
	labeling([min(MAX)],C),

	% escriptura de la sortida
	write('Temps minim: '), write(MAX), nl, 
	write('Distribucio de tasques per PC: '), nl,
	write([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14]), !.



% concatenacio de varies llistes
concat([],[]).
concat([X|LS],F):- concat(LS,F2), append(X,F2,F).


% maxim d_una llista de nombres
maxim([X],X).
maxim([X|LS],M):- maxim(LS,M), X #< M.
maxim([X|_],X).