#!/bin/bash

if [ -d reopt ]; then
	echo "reopt already exists"
	exit 1
fi

mkdir reopt
cp *-p1.chk reopt
cp *-p1.gjf reopt
cd reopt

rename p1 RO *
Z=$(basename *.chk .chk)

cp ~/bin/subG09TZVP.sh .

touch $Z.gjf

OPTKEYWORD=$(awk '{print $2}' $Z.gjf | head -1)

sed -i "s/$OPTKEYWORD/opt=(TS,noeigentest,calcfc,tight,maxcycles=200)/" $Z.gjf

D=$(basename *.gjf .gjf)
E=$(basename *.sh)

if (( "${#D}" >= 12 ));
then
    	new_D=${D:1:15}
        D=$new_D
fi

qsub -N $D $E
