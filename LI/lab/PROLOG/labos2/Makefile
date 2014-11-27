file = solveWithSAT

$(file): $(file).pl
	swipl -O -g main --stand_alone=true -o $(file) -c $(file).pl
	# swipl-ld -o $(file) $(file).pl -lgmp -lrt -lm -lncurses -ldl

clean:
	rm clauses header solveWithSAT infile.cnf
