#!/bin/bash

START=`date +%s%N`

array=($(find . -mindepth 1  -maxdepth 1 -type f -name "*Cu*" -printf '%P\n'))

read -p "Element = " ele
read -p "Charge,Mulitplicity in (C,M) format = " CM
#read -p "Number of (OH) group = " OH

#if [ $OH -eq 1 ]; then
	for d in "${array[@]}"; do
       		[ -d $d ]
        	echo $d
		sed -i 's/Cu(OH) (Cu+0)/'$ele'(OH) ('$ele'+2)/' $d
	        sed -i 's/0,1/'$CM'/' $d
        	sed -i 's/Cu/'$ele'/' $d
	        rename Cu "$ele"_"${CM:0:1}${CM:2:3}"_ $d
	done
#else
#	for d in "${array[@]}"; do
#       	[ -d $d ]
#		echo $d
#	        sed -i 's/Cu(OH)2 (Cu+2)/'$ele'(OH)'$OH' ('$ele'+'$OH')/' $d
#        	sed -i 's/0,2/'$CM'/' $d
#	        sed -i 's/Cu/'$ele'/' $d
#        	rename Cu $ele $d
#	done
#fi

array2=($(find . -mindepth 1  -maxdepth 1 -type f -name "*${ele}*.gjf" -printf '%P\n'))

for e in "${array2[@]}"; do
       [ -d $e ]
       filename="${e%.*}"
       mkdir $filename
       mv $e $filename
       cp ~/bin/subG09TZVP.sh $filename
done

array4=($(find . -mindepth 1  -maxdepth 1 -type d -name "*${ele}*"  -printf '%P\n'))

for g in "${array4[@]}"; do
       [ -d $g ] && cd "$g"
        echo "$g"
        A=$(basename *.gjf .gjf)
        B=$(basename *.sh)
        sleep 3
        qsub -N $A $B
        cd -
done

END=`date +%s%N`

echo "---FINISHED---" 

ELAPSED=`echo "scale=8; ($END - $START) / 1000000000" | bc`

echo $ELAPSED secs

