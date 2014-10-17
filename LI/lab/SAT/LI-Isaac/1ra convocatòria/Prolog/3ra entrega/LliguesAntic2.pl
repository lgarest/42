:-include(entradaLigasEasy).
:-dynamic(varNumber/3).
symbolicOutput(1). % set to 1 to see symbolic output only; 0 otherwise.

numEquips(6).
numJornades(N):- numEquips(N1), N is N1-1.
writeClauses:-
	atLeastOneMatchPerJourney,
	%atMostOneMatchPerJourney,
	noRepeatMatch.
	%noTripitir,
	%noFora,
	%noCasa,
	%noRepes,
	%impossibles,
	%obligats.


% -------------------------------------------------------------------------------------------
% Per a cada jornada, cada equip com a minim un partit (casa o fora)
atLeastOneMatchPerJourney:-
	numEquips(Ne), numJornades(Nj),
	between(1,Nj,K), between(1,Ne,I),
	findall(x-I-J1-K, (between(1,Ne,J1), I \= J1), W1),
	findall(x-J2-I-K, (between(1,Ne,J2), I \= J2), W2),
	append(W1,W2,W),
	writeClause(W), fail.
atLeastOneMatchPerJourney.


% -------------------------------------------------------------------------------------------
% Per a cada jornada, cada equip com a maxim un partit (casa o fora)
atMostOneMatchPerJourney:-
    numEquips(Ne), numJornades(Nj),
	between(1,Ne,I), between(1,Nj,K), 
	between(1,Ne,J1), between(1,Ne,J2),
	I \= J1, I < J2,
	writeClause([ \+x-I-J1-K, \+x-J2-I-K ]),	% casa - fora
	J1 < J2,
	writeClause([ \+x-I-J1-K, \+x-I-J2-K ]), fail.	% casa - casa

	%fora()
	%casa(I,K,J1,J2), fail.
atMostOneMatchPerJourney.


% -------------------------------------------------------------------------------------------
% A cada jornada contra un de diferent
noRepeatMatch:-
	numEquips(Ne), numJornades(Nj),
	between(1,Ne,I), between(1,Ne,J),
	I \= J,
	between(1,Nj,K1), between(1,Nj,K2), 
	K1 < K2,
	writeClause([ \+x-I-J-K1, \+x-J-I-K2 ]),	% casa - fora
	writeClause([ \+x-I-J-K1, \+x-I-J-K2 ]), fail.	% casa - casa
noRepeatMatch.


% -------------------------------------------------------------------------------------------
% No es permeten tripiticions
noTripitir:-
	numEquips(Ne), numJornades(Nj),
	between(1,Ne,I), between(1,Nj,K1),
	K2 is K1+1,	K3 is K2+1, K3 =< Nj,
	between(1,Ne,J1), between(1,Ne,J2), between(1,Ne,J3),
	J1 < J2, J2 < J3,
	J1 \= I, J2 \= I, J3 \= I,
	permutation([J1,J2,J3],[Ja,Jb,Jc]),
	writeClause([ \+x-I-Ja-K1, \+x-I-Jb-K2, \+x-I-Jc-K3 ]),
	writeClause([ \+x-Ja-I-K1, \+x-Jb-I-K2, \+x-Jc-I-K3 ]), fail.
noTripitir.


% -------------------------------------------------------------------------------------------
% Partits que un equip no vol jugar a casa
noCasa:-
	nocasa(I,K),
	numEquips(Ne),
	between(1,Ne,J),
	I \= J,
	writeClause([\+x-I-J-K]), fail.
noCasa.


% -------------------------------------------------------------------------------------------
% Partits que un equip no vol jugar a fora
noFora:-
	nofuera(I,K),
	numEquips(Ne),
	between(1,Ne,J),
	I \= J,
	writeClause([\+x-J-I-K]), fail.
noFora.


% -------------------------------------------------------------------------------------------
% Partits que un equip no vol jugar a fora
noRepes:-
	norepes(K1,K2),
	numEquips(Ne),
	between(1,Ne,I), between(1,Ne,J1), between(1,Ne,J2),
	J1 \= J2, J1 \= I, J2 \= I,
	writeClause([\+x-I-J1-K1, \+x-I-J2-K2]), fail.
noRepes.


% -------------------------------------------------------------------------------------------
% Partits que s_han de fer si o si
obligats:-
	sipartido(I,J,K),
	writeClause([x-I-J-K , x-J-I-K]), fail.
obligats.


% -------------------------------------------------------------------------------------------
% Partits que no es poden fer
impossibles:-
	nopartido(I,J,K),
	writeClause([\+x-I-J-K]), 
	writeClause([\+x-J-I-K]), fail.
impossibles.


% -------------------------------------------------------------------------------------------
displaySol([]).
displaySol([Nv|S]):- 
	num2var(Nv,x-I-J-K),
	write(I), write(','), write(J), write(' jor. '), write(K),
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
