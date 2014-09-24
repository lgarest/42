CC = gcc
C2 = g++
CFLAGS = -I/usr/include/pccts/

all: example0 example1

example0: example0.c
	$(CC) -o example0 example0.c scan.c err.c $(CFLAGS)
	rm -f *.o scan.c err.c parser.dlg tokens.h mode.h
example0.c: example0.g
	antlr example0.g
	dlg parser.dlg scan.c

example1: example1.c
	$(C2) -o example1 example1.c scan.c err.c $(CFLAGS)
	rm -f *.o scan.c err.c parser.dlg tokens.h mode.h
example1.c: example1.g
	antlr -gt example1.g
	dlg -ci parser.dlg scan.c

clean:
	rm -f *.o example0 example0.c scan.c err.c parser.dlg tokens.h mode.h example1 example1.c
