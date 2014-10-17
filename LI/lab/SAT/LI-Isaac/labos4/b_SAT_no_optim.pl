:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

writeClauses:-
	min1, maxall.


datosEjemplo( [[1,2,6],[1,6,7],[2,3,8],[6,7,9],[6,8,9],[1,2,4],[3,5,6],[3,5,7],
[5,6,8],[1,6,8],[4,7,9],[4,6,9],[1,4,6],[3,6,9],[2,3,5],[1,4,5],
[1,6,7],[6,7,8],[1,2,4],[1,5,7],[2,5,6],[2,3,5],[5,7,9],[1,6,8]] ).



 % xerrades obligades (perque algu la vol)
 min1:-
 	datosEjemplo(L), member([X1,X2,X3],L), between(1,3,S),
 	writeClause([x-X1-S, x-X2-S, x-X3-S]), fail.
 min1.

 % xerrades obligades (perque algu la vol)
 maxall:-
 	datosEjemplo(L), member([X1,X2,X3],L),
 	writeClause([x-X1-1, x-X1-2, x-X1-3]),
	writeClause([x-X2-1, x-X2-2, x-X2-3]),
	writeClause([x-X3-1, x-X3-2, x-X3-3]),
 	fail.
 maxall.



%noalhora:-
%	datosEjemplo(L), member([X1,X2,X3],L), between(1,3,S),
%	writeClause([\+x-X1-S, \+x-X2-S]),
%	writeClause([\+x-X1-S, \+x-X3-S]),
%	writeClause([\+x-X2-S, \+x-X3-S]), fail.
%noalhora.


displaySol([Nv|S]):- 
	num2var(Nv,x-N-Ses), write('Numero '), write(N), write(' Sessio '), write(Ses), nl, displaySol(S).
displaySol(_).

% ========== No need to change the following: =====================================
main:- symbolicOutput(1), !, writeClauses, halt. % escribir bonito, no ejecutar
main:-  assert(numClauses(0)), assert(numVars(0)),
	tell(clauses), writeClauses, told,
	tell(header),  writeHeader,  told,
	unix('cat header clauses > infile.cnf'), unix('picosat -o model < infile.cnf'),
	see(model), readModel(M), seen, nl, displaySol(M), halt.
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