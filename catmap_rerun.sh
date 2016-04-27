#!/bin/bash
#

declare -i num
num=$(ls -lR | grep ^d | grep 'run*' | wc -l)
num+=1

mkdir run$num

mv TABLES run$num
mv IMAGES run$num
mv CATMAP.o* run$num
mv *.log run$num
mv *.pkl run$num
mv stand_alone.py run$num
mv model_info.tex run$num
mv *table.txt run$num

find -maxdepth 1 -type f -exec cp {} run$num \;
