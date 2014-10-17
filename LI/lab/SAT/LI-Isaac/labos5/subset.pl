subset([],[]).
subset([X|L],[X|S]):-subset(L,S).
subset([X|L], S ):-subset(L,S).