#!/bin/bash

START=`date +%s%N`

array1=($(find . -mindepth 1  -maxdepth 1 -type f -name "*.gjf" -printf '%P\n'))

for e in "${array1[@]}"; do
        [ -d $e ]
        filename="${e%.*}"
        mkdir $filename
        mv $e $filename
        cp ~/bin/subG09-multi.sh $filename
        new_dir+=("$filename")
done

for g in "${new_dir[@]}"; do
       [ -d $g ] && cd "$g"
        echo "$g"
	A=$(basename *.gjf .gjf) 
	B=$(basename *.sh) 
        sleep 5
	qsub -N $A $B
        cd -
done

END=`date +%s%N`

echo "---FINISHED---" 

ELAPSED=`echo "scale=8; ($END - $START) / 1000000000" | bc`

echo $ELAPSED secs
