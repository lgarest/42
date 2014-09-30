CC=g++
CFLAGS=-lglut -lGL
FILENAME=B2_luis.garcia

all: bloque1

bloque1: $(FILENAME).c
	$(CC) $(FILENAME).c $(CFLAGS) -o $(FILENAME).exe

exe:
	./$(FILENAME).exe

clean:
	rm *.exe
