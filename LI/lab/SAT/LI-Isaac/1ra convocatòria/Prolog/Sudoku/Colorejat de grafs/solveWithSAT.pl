:-include(graphColoringInstance1).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

% number of vars, translation form numeric to symbolic, and vice versa
% Donada una variable x amb subindex calcular el seu identificador
% Nv = nombre de variables (en el cas del sudoku serà 9x9)
numVars(Nv):- numNodes(N), numColors(K), Nv is N*K,!.
var2num(x-I-J,Nv):- numColors(K), Nv is 1 + (I-1)*K + (J-1), !.
num2var(Nv,x-I-J):- numColors(K), I is 1+(Nv-1)//K,  J is 1+(Nv-1) mod K, !.

writeClauses:- atleastOneColorPerNode, atmostOneColorPerNode, differentColors.
% between es com un nat pero entre 1 i N

% Per a tot node i: Qi1 v Qi2 v Qi3 v...v Qi,k 
atleastOneColorPerNode:- numNodes(N), numColors(K), between(1,N,I),
	% Troba totes les variables x sub I i J que estiguin entre 1 i K
	findall( x-I-J, between(1,K,J), C ), writeClause(C), fail.
atleastOneColorPerNode.

% Per a tot node i, per a tota c < c': -Qi,c v Qic'
atmostOneColorPerNode:- numNodes(N), numColors(K), 
	between(1,N,I), between(1,K,J1), between(1,K,J2), J1<J2,
	writeClause( [ \+x-I-J1, \+x-I-J2 ] ), fail.
atmostOneColorPerNode.

% Per a tot node i,i', per a tota c: -Qic v -Qi'c 
differentColors:- edge(I1,I2), numColors(K), between(1,K,J),
	writeClause( [ \+x-I1-J, \+x-I2-J ] ), fail.
differentColors.

displaySol([]).
displaySol([Nv|S]):- num2var(Nv,x-I-J), write(I), write(': color '), write(J), nl, displaySol(S).


% ========== No need to change the following: =====================================
main:- symbolicOutput(1), !, writeClauses, halt. % escribir bonito, no ejecutar
main:- assert(numClauses(0)), tell(clauses), writeClauses, told,
    tell(header),  writeHeader,  told,
    unix('cat header clauses > infile.cnf'), unix('picosat -o model infile.cnf'),
    see(model), readModel(M), seen, displaySol(M), halt.
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
