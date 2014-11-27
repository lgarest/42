### Author: Luis García Estrades
### SubGroup: 13

CC=g++
FILE=roomba
CFLAGS = -I/usr/include/pccts/

all: clear clean $(FILE)

$(FILE): $(FILE).c
	$(CC) -w -o $(FILE).exe $(FILE).c scan.c err.c $(CFLAGS)

$(FILE).c: $(FILE).g
	antlr -gt $(FILE).g
	dlg -ci parser.dlg scan.c

# test: clear
# 	./$(FILE).exe < inputtest.txt

# orig: clear
# 	./$(FILE).exe < inputorig.txt

clear:
	clear

clean:
	rm -f *.o *.c $(FILE).exe parser.dlg tokens.h mode.h scan.c err.c ; clear
