CC=g++
O=-O3
FILE=SAT-alumnes
FILE2=SAT-alumnes2

all: clear sat sat2 exe2

clear:
	clear

sat: $(FILE).cpp
	$(CC) -o $(FILE).exe $(FILE).cpp $(O)
exe: exevars6
exe2: exevars62

exevars6:
	./$(FILE).exe < random3SAT/vars-6.cnf

sat2: $(FILE).cpp
	$(CC) -o $(FILE2).exe $(FILE2).cpp $(O)
exevars62:
	./$(FILE2).exe < random3SAT/vars-6.cnf

