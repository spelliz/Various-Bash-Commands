#!/bin/bash

read -p "Temp (K) [383.15] = " TEMP_tmp
TEMP=${TEMP_tmp:=383.15}
read -p "Pressure (ATM) [0.000657894737] = " PRES_tmp
PRES=${PRES_tmp:=0.000657894737}
read -p "Scaling Factor [1] = " SCALE_tmp
SCALE=${SCALE_tmp:=1}

ENERGY=$(grep -i "scf done" *.log | tail -1 | grep -o '[-][0-9]*.[0-9]*')
CHK=*.chk

echo "Energy = "$ENERGY
echo Temp,Pres,Enthapy,Gibbs

/software/gaussian/g09/freqchk $CHK -o tmp.dat N $TEMP $PRES $SCALE Y N
ENTHALPY=$(grep "Thermal correction to Enthalpy" tmp.dat | grep -o '[0-9].[0-9]*')
GIBBS=$(grep "Thermal correction to Gibbs Free Energy" tmp.dat | grep -o -e '[0-9].[0-9]*' -e '[-][0-9].[0-9]*')
T_ENTHALPY=$(echo $ENTHALPY + $ENERGY |bc -l)
T_GIBBS=$(echo $GIBBS + $ENERGY |bc -l)
echo $TEMP','$PRES','$T_ENTHALPY','$T_GIBBS
rm tmp.dat
