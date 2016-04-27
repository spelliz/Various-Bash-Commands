declare -a Species_names

Species_names=( $(find /common/curium/spelliz/Oxidation/MOH/MOH_input -type f -name "*.gjf") )

declare -a names 

for i in "${Species_names[@]}"; do
	names+=($(basename ${i##/common/curium/spelliz/Oxidation/MOH/MOH_input/Group-[123]/CuOH-} .gjf))
done

echo "Final List:"
echo ${names[@]}


for j in "${names[@]}"; do
	echo "FILENAME ENERGY ZPE H.CORR G.CORR Entropy #IMAG Charge/Multiplicity Stability S**2" > $j.csv
	grep "OH-$j"  $1 | sort | cut -f 1,5,8 -d' ' >> $j.csv
	
done

Files=( $(find . -type f -name "*.csv") )

for k in "${Files[@]}"; do 
	species=( $(cat $k | cut -c 1-2 | uniq | grep [A-Z][a-zO]) )
	for m in "${species[@]}"; do
		grep $m $k | sort -n -k2 |head -1  >> Minimum_Energies.csv
	done
	
done

for n in "${names[@]}"; do
        echo "FILENAME G.CORR Charge/Multiplicity"  > min-$n.csv
        grep "OH-$n"  Minimum_Energies.csv | sort  >> min-$n.csv

done


