#!/bin/bash

if [ -d Reopt ]; then
	echo "Reopt already exists"
	exit 1
fi

mkdir Reopt
cp *-p1.chk Reopt
cp *-p1.gjf Reopt
cd Reopt

rename p1 RO *
Z=$(basename *.chk .chk)

cp ~/bin/subG09-multi.sh .

touch $Z.gjf

OPTKEYWORD=$(awk '{print $2}' $Z.gjf | head -1)

sed -i "s/$OPTKEYWORD/opt=(calcfc,tight,maxcycles=200)/" $Z.gjf

D=$(basename *.gjf .gjf)
E=$(basename *.sh)

if (( "${#D}" >= 12 ));
then
    	new_D=${D:1:15}
        D=$new_D
fi

qsub -N $D $E
