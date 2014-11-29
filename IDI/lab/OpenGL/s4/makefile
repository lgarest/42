CC=g++
CFLAGS=-lglut -lGL -lGLU
FILENAME=B4_luis.garcia
MODEL=model.cpp

all: compile clear execute

compile: $(FILENAME).cpp
	$(CC) -o $(FILENAME).exe $(FILENAME).cpp $(MODEL) $(CFLAGS)

execute:
	./$(FILENAME).exe

clear:
	clear

clean:
	rm *.exe
