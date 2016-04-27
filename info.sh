#!/bin/bash
#info.sh

# Original script
#	author: Steven Pellizzeri <spelliz (at) clemson (dot) edu>
#	creation date: July 13, 2015

# Purpose: To compile the commonly useful data from Gaussian output

# Updates: 
#       January 15, 2016:
#       Added support of ONIOM calcualtions since the energy term is different

# Generates Filename
Filename=$PWD
echo Filename = "$Filename"
#echo Filename = "${Filename##/common/curium/$USER/}"

# Find charge and mulutplicity
CM=$(grep "Charge = [- ][0-9] Multiplicity = [0-9]" *.log | head -1 | grep -o  [0-9] | sed ':a;N;$!ba;s/\n/,/')
echo "Charge/Multiplicity = ${CM}"

# Determine termination status
echo "---Termination Status---"
grep "Normal termination" *.log
grep "Error in" *.log | grep -Ev "Error in corrector energy ="
grep "Error termination request processed by link 9999." *.log
grep "Error termination" *.log
grep "galloc:  could not allocate memory." *.log

# Search output for imaganary frequencies
echo "---imaganary frequencies---"
if [ -d freq ];  then  
	awk '/N/,/g=/' freq/*.log | tr -d '\n' | tr -d ' '| grep -o -q  "NImag=0" && echo "No Imaganary Frequencies"
	a=$(awk '/N/,/g=/' freq/*.log | tr -d '\n' | tr -d ' '| grep -o "NImag=[1-9]") && echo "********** Imaganary Frequencies = ${a/NImag=} **********"
	awk '/N/,/g=/' freq/*.log | tr -d '\n' | tr -d ' '| grep -o -q  "NImag=" || echo "No Frequencies"
else
	awk '/N/,/g=/' *.log | tr -d '\n' | tr -d ' '| grep -o -q  "NImag=0" && echo "No Imaganary Frequencies"
	a=$(awk '/N/,/g=/' *.log | tr -d '\n' | tr -d ' '| grep -o "NImag=[1-9]") && echo "********** Imaganary Frequencies = ${a/NImag=} **********"
	awk '/N/,/g=/' *.log | tr -d '\n' | tr -d ' '| grep -o -q  "NImag=" || echo "No Frequencies"
fi

# Find electronic energy
echo "---SCF Energies---"
echo -n "SCF CYCLES=" 
grep -c "SCF Done" *.log

if grep -q oniom *.gjf; then
        if [ -d freq ];  then  
                grep "ONIOM: extrapolated energy" freq/*.log | tail -n 1
       	else
                grep "ONIOM: extrapolated energy" *.log | tail -n 1
       	fi
else 
	if [ -d freq ];  then  
		grep "SCF Done" freq/*.log | tail -n 1
	else
    		grep "SCF Done" *.log | tail -n 1
	fi
fi

# Find the Thermal Corrections from an frequency job
echo "---Thermal Correction---"
if [ -d freq ];  then
	grep "Zero-point correction=" freq/*.log
	grep "Thermal correction to Enthalpy=" freq/*.log
	grep "Thermal correction to Gibbs Free Energy=" freq/*.log
	grep -A 2 "E (Thermal)             CV                S" freq/*.log
else
        grep "Zero-point correction=" *.log
        grep "Thermal correction to Enthalpy=" *.log
        grep "Thermal correction to Gibbs Free Energy=" *.log
        grep -A 2 "E (Thermal)             CV                S" *.log
fi

# Find the stability analysis from an stable job
echo "---Stability---" 
if [ -d stable ];  then
	grep "internal instability"  stable/*.log
	grep "UHF instability"  stable/*.log
	grep "The wavefunction is stable under the perturbations considered." stable/*.log
else
	echo "No Stability Check Done"
fi

# Determines the amount of spin Contamination
echo "---Spin Contamination---"
output=$(grep -A 1 "Annihilation of the first spin contaminant:" *.log | tail -1)
if [[ -n $output ]]; then
	echo "$output"
else
	echo "Singlet"
fi

# lists the frequencies
echo "---Frequency List---"

if [ -f frequencies.dat ];
then
	echo $(cat frequencies.dat | sed -n -e 's/^.*= //p')
else
	echo []
fi
