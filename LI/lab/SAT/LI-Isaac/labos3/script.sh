#!/bin/bash

swipl -O -g main --stand_alone=true -o hor -c Horaris.pl
g++ -o comp ComprovadorH.cpp
echo -e "\n\n"
./hor > in
./comp < in