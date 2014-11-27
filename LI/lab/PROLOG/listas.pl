pert(X, [X|_]).
pert(X, [_|L]) :- pert(X, L).

concat([], L, L). % caso base lista vacía
% lista con al menos un elemento
concat([X|L1], L2, [X|L3]) :- concat(L1, L2, L3).

