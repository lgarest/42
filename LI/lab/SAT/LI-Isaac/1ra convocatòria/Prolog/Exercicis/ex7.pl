pert(X,[X|_]).
pert(X,[_|L]):- pert(X,L).

dau(X):- pert(X,[1,2,3,4,5,6]).


