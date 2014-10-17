:- use_module(library(clpfd)).

exec:- L = [A,B,C], L ins 1..5, all_different(L), A+B #= C, labeling([],L), write(L), nl, !.