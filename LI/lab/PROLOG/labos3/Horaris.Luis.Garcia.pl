:-include(entradaHoraris1).
:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.

writeClauses:-
    atLeastUnProfe, atMostUnProfe, prohibides, noClasseAlhora,
    atLeastUnaAula, atMostUnaAula, noAulaAlhora,
    creaVarCurs1, creaVarCurs2, noSolapament, noMesSis, seguides,
    atLeastUnaHoraSessio, atMostUnaHoraSessio, sessionsDiaDiferent.

%----------------------------------------------------------------------------
% var-Assignatura-Profe

% com a mínim un profe per assignatura
% As = assignatura, P = profe, Profes = llista profes
atLeastUnProfe:-
    assig(_,As,_,_,Profes), findall(p-As-P, member(P,Profes), W), writeClause(W), fail.
atLeastUnProfe.


% com a màxim un profe per assignatura
atMostUnProfe:-
    assig(_,As,_,_,Profes),
    member(P1,Profes), member(P2,Profes), P1 < P2,
    writeClause([\+p-As-P1, \+p-As-P2]), fail.
atMostUnProfe.


% hores prohibidies profes
prohibides:-
  assig(_,As,Sessions,_,Profes), member(P,Profes),
  horesProhibides(P,Hores), member(H,Hores),
  between(1,Sessions,S),
  writeClause([ \+p-As-P, \+s-As-S-H ]), fail.
prohibides.


% un mateix profe no pot fer dues classes al mateix temps
noClasseAlhora:-
  assig(_,As1,Sessions1,_,Profes1), member(P,Profes1),
  assig(_,As2,Sessions2,_,Profes2), As1 \= As2, As1 < As2,
  member(P,Profes2), % hem trobat dues assignatures que tenen el mateix profe
  between(1,Sessions1,S1), between(1,Sessions2,S2), setmana(H),
  writeClause([ \+p-As1-P, \+p-As2-P, \+s-As1-S1-H, \+s-As2-S2-H ]), fail.
noClasseAlhora.


%---------------------------------------------------------------------------
% var-Assignatura-Aula

% com a mínim una aula per assignatura
atLeastUnaAula:-
  assig(_,As,_,Aules,_), findall(a-As-Au, member(Au,Aules), W), writeClause(W), fail.
atLeastUnaAula.


% com a màxim una aula per assignatura
atMostUnaAula:-
  assig(_,As,_,Aules,_),
  member(Au1,Aules), member(Au2,Aules), Au1 < Au2,
  writeClause([\+a-As-Au1, \+a-As-Au2]), fail.
atMostUnaAula.


% dues assignatures no es poden fer a la mateixa aula al mateix temps
noAulaAlhora:-
  assig(_,As1,Sessions1,Aules1,_), member(Au,Aules1),
  assig(_,As2,Sessions2,Aules2,_), As1 < As2,
  member(Au,Aules2), % hem trobat dues assignatures que tenen la mateixa aula
  between(1,Sessions1,S1), between(1,Sessions2,S2), setmana(H),
  writeClause([ \+a-As1-Au, \+a-As2-Au, \+s-As1-S1-H, \+s-As2-S2-H ]), fail.
noAulaAlhora.


%----------------------------------------------------------------------------

% noves variables c-curs-hora
% implicacio c-curs-H --> s-As1-_-H v s-As2-_-H v ... = equivalent = -c-curs-H v s-As1-_-H v ...
creaVarCurs1:-
    numCursos(NC), between(1,NC,C), setmana(H),
    findall(s-As-S-H, (assig(C,As,Ss,_,_),between(1,Ss,S)), W1),
    append([\+c-C-H], W1, W2), writeClause(W2), fail.
creaVarCurs1.


% implicacio s-As1-_-H v s-As2-_-H v ...--> c-curs-H =equivalent= (-s-As1-_-H v c-curs-H)i(-s-As2-_-H v c-curs-H) i ...
creaVarCurs2:-
    assig(C,As,Ss,_,_), between(1,Ss,S), setmana(H),
    writeClause([ \+s-As-S-H, c-C-H ]), fail.
creaVarCurs2.


% no més de 6 hores al dia pel mateix curs
noMesSis:-
  numCursos(NC), between(1,NC,C), between(1,5,D),
  dia(D,H1), H2 is H1+1, H3 is H2+1, H4 is H3+1,
  H5 is H4+1, H6 is H5+1, H7 is H6+1, horesDia(D,L),
  member(H7,L),
  writeClause([ \+c-C-H1, \+c-C-H2, \+c-C-H3, \+c-C-H4, \+c-C-H5, \+c-C-H6, \+c-C-H7 ]),
  fail.
noMesSis.


% no es poden solapar hores del mateix curs
noSolapament:-
  assig(C,As1,Sessions1,_,_), assig(C,As2,Sessions2,_,_),
  As1 < As2, between(1,Sessions1,S1), between(1,Sessions2,S2),
  setmana(H), writeClause([ \+s-As1-S1-H, \+s-As2-S2-H ]), fail.
noSolapament.


% les hores d.un curs en un dia han de ser seguides
seguides:-
    numCursos(NC), between(1,NC,C), between(1,5,D),
    dia(D,H1), H2 is H1+1, dia(D,H3), H2 < H3,
    writeClause([ \+c-C-H1, c-C-H2, \+c-C-H3 ]), fail.
seguides.

%----------------------------------------------------------------------------

setmana(H):- between(1,60,H).
dia(D,H):- N2 is D*12, N1 is N2-11, findall(I, between(N1,N2,I), L), member(H,L).
horesDia(D,L):- N2 is D*12, N1 is N2-11, findall(I, between(N1,N2,I), L).

% com a mínim una hora per sessió d.assignatura
atLeastUnaHoraSessio:-
  assig(_,As,Hores,_,_), between(1,Hores,Sessio),
  findall(s-As-Sessio-H, setmana(H), W), writeClause(W), fail.
atLeastUnaHoraSessio.


% com a màxim una hora per sessió d.assignatura
atMostUnaHoraSessio:-
  assig(_,As,Hores,_,_), between(1,Hores,Sessio),
  setmana(H1), setmana(H2), H1 < H2,
  writeClause([ \+s-As-Sessio-H1, \+s-As-Sessio-H2 ]), fail.
atMostUnaHoraSessio.


% no hi poden haver dues sessions de la mateixa assignatura al mateix dia
sessionsDiaDiferent:-
  assig(_,As,Hores,_,_),
  between(1,Hores,S1), between(1,Hores,S2), S1 < S2,
  between(1,5,D), dia(D,H1), dia(D,H2), H1 =< H2,
  writeClause([ \+s-As-S1-H1, \+s-As-S2-H2 ]),
  writeClause([ \+s-As-S1-H2, \+s-As-S2-H1 ]), fail.
sessionsDiaDiferent.


%--------------------------------

displaySol([Nv|S]):-
  num2var(Nv,p-As-P), write('Assig '), write(As), write('  Profe '), write(P), nl, displaySol(S).
displaySol([Nv|S]):-
  num2var(Nv,a-As-Au), write('Assig '), write(As), write('  Aula '), write(Au), nl, displaySol(S).
displaySol([Nv|S]):-
  num2var(Nv,s-As-_-H), write('Assig '), write(As), write('  Hora '), write(H), nl, displaySol(S).
displaySol([Nv|S]):-
  num2var(Nv,c-C-H), write('Curs '), write(C), write('  Hora '), write(H), nl, displaySol(S).
displaySol(_).

prohib:-
  horesProhibides(P,L), write('Profe '), write(P), write(' Prohib'), llista(L), write(' -1'), nl, fail.
prohib.

llista([]).
llista([X|L]):- write(' '), write(X), llista(L).

assighores:-
  assig(_,A,H,_,_), write('Assig-Hores '), write(A), write(' '), write(H), nl, fail.
assighores.

% ========== No need to change the following: =====================================
main:- symbolicOutput(1), !, writeClauses, halt. % escribir bonito, no ejecutar
main:-  assert(numClauses(0)), assert(numVars(0)),
    tell(clauses), writeClauses, told,
    tell(header),  writeHeader,  told,
    unix('cat header clauses > infile.cnf'), unix('picosat -o model < infile.cnf'),
    see(model), readModel(M), seen, numAssignatures(NA), write(NA), nl, numCursos(NC), write(NC),
    nl, numProfes(NP), write(NP), nl, displaySol(M), prohib, assighores, halt.
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
