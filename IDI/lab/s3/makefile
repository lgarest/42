CC=g++
CFLAGS=-lglut -lGL -lGLU
FILENAME=B3_luis.garcia
FILENAME1=B3_s1_luis.garcia
MODEL=../models/model.cpp

all: bloque3 bloque3s1 clear exe0

clear:
	clear

bloque3: $(FILENAME).c
	$(CC) -o $(FILENAME).exe $(FILENAME).c $(MODEL) $(CFLAGS)

bloque3s1: $(FILENAME1).c
	$(CC) -o $(FILENAME1).exe $(FILENAME1).c $(MODEL) $(CFLAGS)

exe0:
	./$(FILENAME).exe

exe1:
	./$(FILENAME1).exe

clean:
	rm *.exe
