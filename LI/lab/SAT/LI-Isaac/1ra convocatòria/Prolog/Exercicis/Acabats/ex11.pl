esta_ordenada([]). % Contemplem aquest cas
esta_ordenada([_]):- !.
esta_ordenada([X,Y|L]):- X < Y, esta_ordenada([Y|L]).
