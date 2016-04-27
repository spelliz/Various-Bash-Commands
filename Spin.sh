#!/bin/bash

mkdir SPIN
cp *.gjf  SPIN
cp sub* SPIN
cd SPIN

Z=$(basename *.gjf .gjf)
rename ${Z:5} ${Z:5}s *

A=$(grep -o '[0,9][ ,][1-9]' *.gjf | head -1)
let B=$(expr ${A:2} + 2)

sed -i "s/\<$A\>/${A:0:1},$B/" *.gjf

D=$(basename *.gjf .gjf)
E=$(basename *.sh)

qsub -N $D $E
