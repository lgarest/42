:- use_module(library(clpfd)).

% L_overflow depen de l_ordinador on es provi
% En el meu portatil es a partir del 20.000 aprox.

% Un factorial normal sense gaire secret
fact(1,1).
fact(N,F):- 
	N1 #= N-1,
	fact(N1,F1),
	F #= F1*N, !.