CC=g++
CFLAGS=-lglut -lGL
FILENAME=B2_luis.garcia
MODEL=model.cpp

all: bloque1

bloque1: $(FILENAME).c
	$(CC) -o $(FILENAME).exe $(FILENAME).c $(MODEL) $(CFLAGS)

exe:
	./$(FILENAME).exe

clean:
	rm *.exe
