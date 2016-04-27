#!/bin/bash

START=`date +%s%N`

read -p "Old Element = " old_ele

if [ -z "$(find . -name "*$old_ele*")" ]; then 
	echo "Element is not Found"
        exit 1
fi

array=($(find . -mindepth 1  -maxdepth 1 -type f -name "*$old_ele*" -printf '%P\n'))

read -p "New Element = " ele
read -p "Charge,Mulitplicity in (C,M) format = " CM

for d in "${array[@]}"; do
	[ -d $d ]
        echo $d
	REPLACE=$(awk '{print $1}' $d | grep $old_ele | head -n 1)
	old_CM=$(grep -n "[01][,][1-9]" $d | tail -1)
	sed -i "s/$REPLACE/$ele/" $d
	sed -i 's/'$old_ele'(OH) ('$old_ele'+0)/'$ele'(OH) ('$ele'+0)/' $d
	sed -i ''${old_CM:0:1}'s/.*/'$CM'/' $d
        sed -i 's/'$old_ele'/'$ele'/' $d
	rename $old_ele "$ele"_"${CM:0:1}${CM:2:3}" $d
done

array2=($(find . -mindepth 1  -maxdepth 1 -type f -name "*${ele}*.gjf" -printf '%P\n'))

for e in "${array2[@]}"; do
       	[ -d $e ]
       	filename="${e%.*}"
       	mkdir $filename
       	mv $e $filename
       	cp ~/bin/subG09-single.sh $filename
	new_dir+=("$filename") 
done

#for g in "${new_dir[@]}"; do
#       [ -d $g ] && cd "$g"
#        echo "$g"
#        A=$(basename *.gjf .gjf)
#        B=$(basename *.sh)
#        sleep 3
#        qsub -N $A $B
#        cd -
#done

END=`date +%s%N`

echo "---FINISHED---" 

ELAPSED=`echo "scale=8; ($END - $START) / 1000000000" | bc`

echo $ELAPSED secs

