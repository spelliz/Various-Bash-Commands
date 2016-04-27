#!/bin/bash

if [ -d MIX ]; then
        echo "MIX already exists"
        exit 1
fi

mkdir MIX
cp ../*.gjf  MIX
cd MIX

Z=$(basename *.gjf .gjf)

mv $Z.gjf $Z-mix.gjf

cp ~/bin/subG09-multi.sh .

OPTKEYWORD=$(awk '{print $2}' $Z-mix.gjf | head -1)

sed -i "s/$OPTKEYWORD/$OPTKEYWORD guess=(Mix)/" $Z-mix.gjf

D=$(basename *.gjf .gjf)
E=$(basename *.sh)

if (( "${#D}" >= 12 ));
then
    	new_D=${D:1:15}
        D=$new_D
fi

qsub -N $D $E
