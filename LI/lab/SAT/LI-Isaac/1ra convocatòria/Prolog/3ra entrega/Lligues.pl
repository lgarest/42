:-include(entradaLigasEasy).
:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

% Com between pero amb decreixement
between2(_,High,High).
between2(Low,High,Out):- NewLow is High-1, NewLow >= Low, between2(Low, NewLow, Out).

% Com between pero incrementa de 2 en 2
between3(Low,_,Low).
between3(Low,High,Out):- NewLow is Low+2, NewLow =< High, between3(NewLow, High, Out).

numEquips(10).
numJornades(N):- numEquips(N1), N is N1-1.
totalJornades(N):- numJornades(N1), N is N1*2.
numVaris(N):- numEquips(Ne), numJornades(Nj), totalJornades(Tj), N is Ne*Tj*Nj.
volta2volta(K1,K2):- totalJornades(Tj), K2 is Tj-K1+1.
writeClauses:-
	atLeastOneMatchPerJourney,
	tornada,
	varCasa1,
	varCasa2,
	varRepes1,
	varRepes2,
	noRepeatMatchCasa,
	noRepeatMatchFora,
	noTripitir,
	noFora,
	noCasa,
	noRepes,
	impossibles,
	obligats,
	maxRepes.


% -------------------------------------------------------------------------------------------
% Per a cada jornada, cada equip com a minim un partit (casa o fora)
atLeastOneMatchPerJourney:-
	numEquips(Ne), numJornades(Nj),
	between(1,Nj,K), between(1,Ne,I),	% Per mostrar ordenat per jornada
%	between(1,Ne,I), between(1,Nj,K),	% Per mostrar ordenat per equip
	findall(x-I-J1-K, (between(1,Ne,J1), I \= J1), W1),
	findall(x-J2-I-K, (between(1,Ne,J2), I \= J2), W2),
	append(W1,W2,W),
	writeClause(W), fail.
atLeastOneMatchPerJourney.


% -------------------------------------------------------------------------------------------
% Tot partit equip a vs b ha de tenir una tornada equip b vs a
tornada:-
	numEquips(Ne), numJornades(Nj),
	between(1,Nj,K), between(1,Ne,J), between(1,Ne,I), I \= J,
	volta2volta(K,K2),
	writeClause([ \+x-I-J-K, x-J-I-K2 ]),
	writeClause([ x-I-J-K, \+x-J-I-K2 ]), fail.
tornada.


% -------------------------------------------------------------------------------------------
% varCasa1 i varCasa2 creen un conjunt de variables casa-I-K que significa
% que l_equip I juga a casa a la jornada K
% Per a tot equip 'i' i jornada 'k':
% casa-i-k --> Qi1k v Qi2k v..v Qijk
% -casa-i-k --> Q1ik v Q2ik v..v Qjik
varCasa1:-
	numEquips(Ne), numJornades(Nj),
	between(1,Ne,I), between(1,Nj,K),
	findall(x-I-J1-K, (between(1,Ne,J1), I \= J1), W1),
	findall(x-J2-I-K, (between(1,Ne,J2), I \= J2), W2),
	append([\+casa-I-K],W1,F1),					% casa
	append([casa-I-K],W2,F2),					% fora
	writeClause(F1), writeClause(F2), fail.
varCasa1. 

% Per a tot equip 'i','j' i jornada 'k':
% casa-i-k <-- -Qijk
% -casa-i-k <-- -Qijk
varCasa2:-
	numEquips(Ne), numJornades(Nj),
	between(1,Ne,I), between(1,Nj,K), between(1,Ne,J),
	I \= J,
	writeClause([ casa-I-K, \+x-I-J-K ]), 
	writeClause([ \+casa-I-K, \+x-J-I-K ]), fail.
varCasa2.


% -------------------------------------------------------------------------------------------
% varRepes1 i varRepes2 creen un conjunt de variables rep-I-K que significa
% que l_equip I repeteix (a casa o a fora) les jornades K i K2-1
% El conjunt de clausules sorgeix de transformar la condicio logica:
% rep-I-K  <-->  (casa-I-(K-1) i casa-I-K) v (-casa-I-(K-1) i -casa-I-K)
varRepes1:-
	numEquips(Ne), totalJornades(Tj),
	between(1,Ne,I), between(2,Tj,K2),
	K1 is K2-1,
	writeClause([ \+rep-I-K2, casa-I-K1, \+casa-I-K1 ]),
	writeClause([ \+rep-I-K2, casa-I-K1, \+casa-I-K2 ]),
	writeClause([ \+rep-I-K2, \+casa-I-K1, casa-I-K2 ]),
	writeClause([ \+rep-I-K2, casa-I-K2, \+casa-I-K2 ]), fail.
varRepes1.

varRepes2:-
	numEquips(Ne), totalJornades(Tj),
	between(1,Ne,I), between(2,Tj,K2),
	K1 is K2-1,
	writeClause([ rep-I-K2, casa-I-K1, casa-I-K2 ]), 
	writeClause([ rep-I-K2, \+casa-I-K1, \+casa-I-K2 ]), fail.
varRepes2.


% -------------------------------------------------------------------------------------------
% A cada jornada contra un de diferent (a casa)
% Per a tot equip 'i','j' i jornada 'k', i != j, k1 != k2:
% -Qijk1 v -Qijk2 i ...
noRepeatMatchCasa:-
	numEquips(Ne), numJornades(Nj),
	between(1,Ne,I), between(1,Ne,J),
	between(1,Nj,K1), between(1,Nj,K2),
	I \= J,
	K1 < K2,
	writeClause([ \+x-I-J-K1, \+x-I-J-K2 ]), fail.
noRepeatMatchCasa.


% -------------------------------------------------------------------------------------------
% A cada jornada contra un de diferent (a fora)
% Per a tot equip 'i','j' i jornada 'k', i != j, k1 != k2:
% -Qijk1, -Qjik2
noRepeatMatchFora:-
	numEquips(Ne), numJornades(Nj),
	between(1,Ne,I), between(1,Ne,J),
	between(1,Nj,K1), between(1,Nj,K2),
	I < J,
	writeClause([ \+x-I-J-K1, \+x-J-I-K2 ]), fail.
noRepeatMatchFora.


% -------------------------------------------------------------------------------------------
% Per a tot equip 'i' i jornada 'k':
% -Cijk v -Cij(k+1) v -Cij(k+2)
% Cijk v Cij(k+1) v Cij(k+2)
noTripitir:-
	numEquips(Ne), numJornades(Nj),
	between(1,Ne,I), between(1,Nj,K1),
	K2 is K1+1, K3 is K2+1,
	writeClause([ \+casa-I-K1, \+casa-I-K2, \+casa-I-K3 ]),
	writeClause([ casa-I-K1, casa-I-K2, casa-I-K3 ]), fail.
noTripitir.


% -------------------------------------------------------------------------------------------
% Jornada que un equip no vol jugar a fora
% Sigui l_equip 'i', per a tota jornada 'k':
% (Depenent de si la restriccio fa referencia a l_anada o la tornada):
% Cijk / -Cijk
noFora:-
	numJornades(Nj),
	nofuera(I,K),
	Nj >= K,
	writeClause([casa-I-K]), fail.
noFora:-
	numJornades(Nj),
	nofuera(I,K),
	Nj < K,
	volta2volta(K,K2),
	writeClause([\+casa-I-K2]), fail.
noFora.


% -------------------------------------------------------------------------------------------
% Jornada que un equip no vol jugar a casa
% Sigui l_equip 'i', per a tota jornada 'k':
% (Depenent de si la restriccio fa referencia a l_anada o la tornada):
% -Cijk / Cijk
noCasa:-
	numJornades(Nj),
	nocasa(I,K),
	Nj >= K,
	writeClause([\+casa-I-K]), fail.
noCasa:-
	numJornades(Nj),
	nocasa(I,K),
	Nj < K,
	volta2volta(K,K2),
	writeClause([casa-I-K2]), fail.
noCasa.


% -------------------------------------------------------------------------------------------
% Partits que no es permet jugar a cap equip els 2 a casa o els 2 a fora en jornades consecutives
noRepes:-
	numJornades(Nj),
	norepes(_,K2),
	Nj >= K2,
	numEquips(Ne),
	between(1,Ne,I),
	writeClause([ \+rep-I-K2 ]), fail.
noRepes:-
	numJornades(Nj),
	norepes(K1,_),
	Nj < K1,
	numEquips(Ne),
	volta2volta(K1,K),
	between(1,Ne,I),
	writeClause([ \+rep-I-K ]), fail.
noRepes.


% -------------------------------------------------------------------------------------------
% Partits que s_han de fer si o si
% Siguin els equips 'i','j', i jornada 'k':
% Qijk v Qjik
obligats:-
	sipartido(I,J,K),
	writeClause([x-I-J-K , x-J-I-K]), fail.
obligats.


% -------------------------------------------------------------------------------------------
% Partits que no es poden fer
% Siguin els equips 'i','j', i jornada 'k':
% -Qijk i -Qjik
impossibles:-
	nopartido(I,J,K),
	writeClause([\+x-I-J-K]),
	writeClause([\+x-J-I-K]), fail.
impossibles.


% -------------------------------------------------------------------------------------------
% No he sabut fer-ho "dinamicament" agafant el nombre maxim K del fitxer
% Esta fet per defecte amb com a maxim 4 (2 anada i 2 tornada), ja que la tornada es simetrica
% Per a tot equip 'i' i jornada 'k':
% -Rijk v -Rij(k+1) v -Rij(K+2)
maxRepes:-
	numEquips(Ne), numJornades(Nj),
	N1 is Nj-1, N2 is Nj-2,
	between(1,Ne,I), between(2,N2,K1), 
	L1 is K1+2, L2 is K1+4,
	between(L1,N1,K2), between(L2,Nj,K3),
	writeClause([ \+rep-I-K1, \+rep-I-K2, \+rep-I-K3 ]), fail.
maxRepes.


% -------------------------------------------------------------------------------------------
displaySol([]).
displaySol([Nv|S]):-
	numVaris(N),
	Nv > N, displaySol(S).
displaySol([Nv|S]):-
	numVaris(N),
	Nv =< N,
	num2var(Nv,x-I-J-K),
	write(I), write(' vs '), write(J), write(' jornada '), write(K),	% Sortida estandard
%	write(K), write(','), write(I), write(','), write(J),				% Sortida pel comprovador
	nl, displaySol(S).


% ========== No need to change the following: =====================================
main:- symbolicOutput(1), !, writeClauses, halt. % escribir bonito, no ejecutar
main:-  assert(numClauses(0)), assert(numVars(0)),
	tell(clauses), writeClauses, told,
	tell(header),  writeHeader,  told,
	unix('cat header clauses > infile.cnf'), unix('picosat -o model infile.cnf'),
	see(model), readModel(M), seen, displaySol(M),
	halt.
var2num(T,N):- hash_term(T,Key), varNumber(Key,T,N),!.
var2num(T,N):- retract(numVars(N0)), N is N0+1, assert(numVars(N)), hash_term(T,Key),
	assert(varNumber(Key,T,N)), assert( num2var(N,T) ), !.
writeHeader:- numVars(N),numClauses(C),write('p cnf '),write(N), write(' '),write(C),nl.
countClause:-  retract(numClauses(N)), N1 is N+1, assert(numClauses(N1)),!.
writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w( Lit ):- symbolicOutput(1), write(Lit), write(' '),!.
w(\+Var):- var2num(Var,N), write(-), write(N), write(' '),!.
w(  Var):- var2num(Var,N),           write(N), write(' '),!.
unix(Comando):-shell(Comando),!.
unix(_).
readModel(L):- get_code(Char), readWord(Char,W), readModel(L1), addIfPositiveInt(W,L1,L),!.
readModel([]).
addIfPositiveInt(W,L,[N|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, !.
addIfPositiveInt(_,L,L).
readWord(99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!.
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
%========================================================================================
