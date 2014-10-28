CC=g++
CFLAGS=-lglut -lGL -lGLU
FILENAME=B3_luis.garcia
FILENAME1=B3_s1_luis.garcia
FILENAME2=B3_s2_luis.garcia
MODEL=../models/model.cpp

all: bloque1s2 clear exe2

clear:
	clear

bloque1: $(FILENAME).c
	$(CC) -o $(FILENAME).exe $(FILENAME).c $(MODEL) $(CFLAGS)

bloque1s1: $(FILENAME1).c
	$(CC) -o $(FILENAME1).exe $(FILENAME1).c $(MODEL) $(CFLAGS)

bloque1s2: $(FILENAME2).c
	$(CC) -o $(FILENAME2).exe $(FILENAME2).c $(MODEL) $(CFLAGS)

exe0:
	./$(FILENAME).exe

exe1:
	./$(FILENAME1).exe

exe2:
	./$(FILENAME2).exe
clean:
	rm *.exe
