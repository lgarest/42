CC=g++
O=-O3
FILES100=random3SAT/vars-1*
FILES200=random3SAT/vars-2*
FILES300=random3SAT/vars-3*
FILE1=SAT-alumnes
FILE2=$(FILE1)2
FILE3=LI-Isaac/SATSolver/SAT
RES=misresultados

all: clear sat sat2 sat3

clear:
	clear

sat: $(FILE1).cpp
	$(CC) -o $(FILE).exe $(FILE1).cpp $(O)

sat2: $(FILE2).cpp
	$(CC) -o $(FILE2).exe $(FILE2).cpp $(O)

exe1:
	echo "sat/insat - time in seconds - decisions - propagations" > $(RES).txt
exe2:
	echo "sat/insat - time in seconds - decisions - propagations" > $(RES)2.txt
exe11:
	for f in $(FILES100) ; do echo "____$$f" >> $(RES)1.txt; ./$(FILE1).exe < $$f >> $(RES)1.txt; done
exe21:
	for f in $(FILES100) ; do echo "____$$f" >> $(RES)2.txt; ./$(FILE2).exe < $$f >> $(RES)2.txt; done


exe12:
	for f in $(FILES200) ; do echo "____$$f" >> $(RES)1.txt; ./$(FILE1).exe < $$f >> $(RES)1.txt; done
exe22:
	for f in $(FILES200) ; do echo "____$$f" >> $(RES)2.txt; ./$(FILE2).exe < $$f >> $(RES)2.txt; done


exe13:
	for f in $(FILES300) ; do echo "____$$f" >> $(RES)1.txt; ./$(FILE1).exe < $$f >> $(RES)1.txt; done
exe23:
	for f in $(FILES300) ; do echo "____$$f" >> $(RES)2.txt; ./$(FILE2).exe < $$f >> $(RES)2.txt; done

clean:
	rm -f *.exe
