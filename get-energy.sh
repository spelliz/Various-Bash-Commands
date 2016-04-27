#!/bin/bash

if [ -d freq ];  then
	/software/gaussian/g09/unfchk freq/*.fchk
else
    	/software/gaussian/g09/unfchk *.fchk
fi

new-freq-strip.sh
info.sh > *.info
Energies.sh && cat Energies.txt && rm Energies.txt

if [ -d freq ];  then
	/software/gaussian/g09/formchk -3 freq/*.chk
	rm -v freq/*.chk
else
	/software/gaussian/g09/formchk -3 *.chk
	rm *.chk
fi

