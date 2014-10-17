:-include(sud22).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

numNums(N):- N is 9.
numFiles(F):- F is 9.
numColumnes(C):- C is 9.
numVars(Nv):- numNums(N), numFiles(F), numColumnes(C), Nv is F*C*N, !.
var2num(x-I-J-K,Nv):- numFiles(F), numColumnes(C), 
					  Nv is 1 + (I-1)*(F*C) + (J-1)*F + (K-1), !.
num2var(Nv,x-I-J-K):- numNums(N), between(1,N,I), between(1,N,J), between(1,N,K), 
					  var2num(x-I-J-K,Nv), !.


% between es com un nat pero entre 1 i N
writeClauses:- atleastOneNumPerSquare, atmostOneNumPerSquare, 
			noRepeatNumRow, noRepeatNumCol, noRepeatNumSquare, omplerts.
	
		   
% -------------------------------------------------------------------------------------------
% Per a tota casella i: Qij1 v Qij2 v Qij3 v...v Qijk, 1 <= i,j,k <= 9
atleastOneNumPerSquare:- numNums(N), numFiles(F), numColumnes(C),
						 between(1,F,I), between(1,C,J),
						 findall(x-I-J-K, between(1,N,K), W), writeClause(W), fail.
atleastOneNumPerSquare.


% -------------------------------------------------------------------------------------------
% Per a tota casella i, per a tota k < k': -Qijk v -Qijk'
atmostOneNumPerSquare:- numNums(N), numFiles(F), numColumnes(C),
						between(1,F,I), between(1,C,J), 
						between(1,N,K1), between(1,N,K2), K1 < K2,
						writeClause([ \+x-I-J-K1, \+x-I-J-K2 ]), fail.
atmostOneNumPerSquare.


% -------------------------------------------------------------------------------------------
% Per a tota casella i, per a tota j < j': -Qijk v -Qij'k
noRepeatNumRow:- numNums(N), numFiles(F), numColumnes(C),
				 between(1,F,I), between(1,N,K), 
				 between(1,C,J1), between(1,C,J2), J1 < J2,
				 writeClause([ \+x-I-J1-K, \+x-I-J2-K ]), fail.
noRepeatNumRow.


% -------------------------------------------------------------------------------------------
% Per a tota casella i < i': -Qijk v -Qi'jk
noRepeatNumCol:- numNums(N), numFiles(F), numColumnes(C),
				 between(1,C,J), between(1,N,K), 
				 between(1,F,I1), between(1,F,I2), I1 < I2,
				 writeClause([ \+x-I1-J-K, \+x-I2-J-K ]), fail.
noRepeatNumCol.


% -------------------------------------------------------------------------------------------
tope(M1,M2):- member([M1,M2],[ [1,3] , [4,6] , [7,9]]).

% Per a tot grup de 3x3 caselles
noRepeatNumSquare:- 
	numNums(N),
	tope(A1,A2), 
	tope(B1,B2),
	
	between(A1,A2,I1), between(B1,B2,J1),
	between(A1,A2,I2), between(B1,B2,J2),
	var2num(x-I1-J1-1,N1), var2num(x-I2-J2-1,N2),
	N2 > N1,
	
	between(1,N,K),
	writeClause([ \+x-I1-J1-K, \+x-I2-J2-K ]), fail.
noRepeatNumSquare.


% -------------------------------------------------------------------------------------------
% Caselles ja omplertes
omplerts:- 
	filled(I,J,K),
	writeClause( [x-I-J-K] ), fail.
omplerts.



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
