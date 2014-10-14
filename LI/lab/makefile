CC=g++
O=-O3
FILE=SAT-alumnes
FILE2=$(FILE)2
FILE3=LI-Isaac/SATSolver/SAT

all: clear sat sat2 sat3 exe2

clear:
	clear

sat: $(FILE).cpp
	$(CC) -o $(FILE).exe $(FILE).cpp $(O)

sat2: $(FILE2).cpp
	$(CC) -o $(FILE2).exe $(FILE2).cpp $(O)

sat3: $(FILE3).cpp
	$(CC) -o $(FILE3).exe $(FILE3).cpp $(O)

exe:
	./$(FILE).exe < random3SAT/vars-6.cnf
exe2:
	./$(FILE2).exe < random3SAT/vars-6.cnf
exe3:
	./$(FILE3).exe < random3SAT/vars-6.cnf
clean:
	rm -f *.exe
