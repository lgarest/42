:- use_module(library(clpfd)).

% SEND + MORE = MONEY
% Solucio: S=9, E=5, N=6, D=7, M=1, O=0, R=8, Y=2

% Tractem cada paraula (send i more) com si fos un natural,
% de manera que cada lletra correspongui a un numero i mirem
% que el resultat de la suma sigui money
resol([S,E,N,D,M,O,R,E,M,O,N,E,Y]) :-
        V = [S,E,N,D,M,O,R,Y],
        V ins 0..9,
        all_different(V),
        (S+M)*1000 + (E+O)*100 + (N+R)*10 + D + E #=
        	M*10000 + O*1000 + N*100 + E*10 + Y,
        M #\= 0,
        label(V), !.