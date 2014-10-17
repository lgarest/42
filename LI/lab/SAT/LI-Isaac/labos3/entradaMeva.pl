numCursos(2).
numAssignatures(17).
numAules(1).
numProfes(2).

% Sintaxi: assig(curs,assignatura,hores,llistaAules,llistaProfessors).
assig(1,1,2,[1],[1]).
assig(1,2,1,[2,3],[1]).
assig(1,3,2,[1,2,3],[1]).
assig(1,4,1,[1,2],[1]).
assig(1,5,3,[1,2,3],[1]).
assig(1,6,1,[1,3],[1]).
assig(1,7,3,[1,2,3],[1]).
assig(1,8,1,[1,2,3],[1]).
assig(1,9,3,[1,3,2],[1]).
assig(1,10,2,[1,3,2],[1]).
assig(2,11,1,[1,2],[1]).
assig(2,12,3,[1,2,3],[1]).
assig(2,13,1,[1,3],[1]).
assig(2,14,3,[1,2,3],[1]).
assig(2,15,1,[1,2,3],[1]).
assig(2,16,3,[1,3,2],[1]).
assig(2,17,2,[1,3,2],[1]).


% Sintaxi: horesProhibides(professor,llistaHores).
horesProhibides(1,[4,7,12,15,16,18,26,29,30,37,38,45,50,54,60]).
horesProhibides(2,[4,5,8,9,12,18,19,28,38,46,49,51,53,55,60]).

