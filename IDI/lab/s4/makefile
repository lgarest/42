CC=g++
CFLAGS=-lglut -lGL -lGLU
FILENAME=B4_luis.garcia
FILENAME1=B4_s1_luis.garcia
MODEL=../models/model.cpp

all: bloque4s1 clear exe1

clear:
	clear

bloque4: $(FILENAME).c
	$(CC) -o $(FILENAME).exe $(FILENAME).c $(MODEL) $(CFLAGS)

bloque4s1: $(FILENAME1).c
	$(CC) -o $(FILENAME1).exe $(FILENAME1).c $(MODEL) $(CFLAGS)

exe0:
	./$(FILENAME).exe

exe1:
	./$(FILENAME1).exe

clean:
	rm *.exe
