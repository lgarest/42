range2(Low, Low, _).
range2(Out,Low,High) :- NewLow is Low+1, NewLow =< High, range(Out, NewLow, High).

range(_,High,High).
range(Low,High,Out) :- NewLow is High-1, NewLow >= Low, range(Low, NewLow, Out).


% Com between pero incrementa de 2 en 2
between3(Low,_,Low).
between3(Low,High,Out) :- NewLow is Low+2, NewLow =< High, between3(NewLow, High, Out).