#!/bin/bash

mkdir IRC
cp *.chk *.gjf IRC

cd IRC

rename p2 IRC *

sed -i s/"freq=noraman"/"IRC=(RCFC,STEPSIZE=10,MAXPOINTS=400,maxcycles=50)"/ *.gjf

cp ~/bin/subG09TZVP-single.sh .

#Sumbit the job
A=$(basename *.gjf .gjf);
B=$(basename *.sh);
if (( "${#A}" >= 12 )); then
	new_A=${A: -12};
        if [[ ${new_A:0:1} == "-" ]]; then
        	A=${new_A:1};
        else
		A=$new_A;
	fi;
fi;
qsub -N $A $B

