L'script adjunt s'encarrega de realitzar tota la tasca de compilació i execució dels programes.
Només s'ha de teclejar a la terminal: ./script.sh

La sortida del programa escrit en Prolog no està pensada per ser llegida "fàcilment".
Per aquest motiu es passa la sortida de "Prolog" com a entrada de l'executable del comprovador (ComprovadorH.cpp).

Aquest últim s'encarrega de printar un horari més intuïtiu i de comprovar que no hi hagi errors.
Si no n'hi ha, apareixerà a dalt de tot de la sortida el missatge "HORARI CORRECTE!".
Si l'horari té errors, escriurà per pantalla tots els problemes trobats seguits del missatge "HORARI INCORRECTE!!!".
En ambdós casos es mostra l'horari obtingut per cada assignatura juntament amb una llista de quin professor i quina aula
correspon a cada assignatura.
