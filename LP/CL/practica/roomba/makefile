CC=g++
FILE=roomba
CFLAGS = -I/usr/include/pccts/

all: clear clean $(FILE) final

$(FILE): $(FILE).c
	$(CC) -o $(FILE).exe $(FILE).c scan.c err.c $(CFLAGS)

$(FILE).c: $(FILE).g
	antlr -gt $(FILE).g
	dlg -ci parser.dlg scan.c

test: clear
	./$(FILE).exe < inputtest.txt

final: clear
	./$(FILE).exe < inputorig.txt

clear:
	clear

clean:
	rm -f *.o *.c $(FILE).exe parser.dlg tokens.h mode.h scan.c err.c ; clear
