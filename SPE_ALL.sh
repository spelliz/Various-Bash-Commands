arr1=( $(find . -type d -iname "*[-][OHCSN]") )
arr2=( $(find . -type d -iname "*[-][OHCSN][H][2]") )
arr3=( $(find . -type d -iname "*[-][OHCSN][H][3]") )
arr4=( $(find . -type d -iname "*[-][OHCSN][H]") )
arr5=( $(find . -type d -iname "*[-][C][A][T]") )

s_arr=( "${arr1[@]}" "${arr2[@]}" "${arr3[@]}" "${arr4[@]}" "${arr5[@]}" )

# echo ${s_arr[@]}

for FILE in ${s_arr[@]}; do
	[ -d $FILE ] && cd "$FILE"
	echo "$FILE"
	mkdir SPE
	find . -maxdepth 1 -type f  \( -iname "*.gjf" ! -iname "*_tmp.gjf" \) -exec cp {} SPE/ \;
	cp ~/bin/subG09-single.sh SPE
	cd -
done

arr5=( $(find . -type d -iname "SPE") )

for SPE in ${arr5[@]}; do
        [ -d $FILE ] && cd "$SPE"
        echo "$SPE"

	input=$(basename *.gjf .gjf)
	rename $input $input-SPE $input.gjf

	D=$(basename *.gjf .gjf)
	sed -i 's/opt=(calcfc,tight) freq=noraman//' $D.gjf
	E=$(basename *.sh)

	if (( "${#D}" >= 12 ));
	then
        	new_D=${D:1:15}
	        D=$new_D
	fi
	sleep 3
	qsub -N $D $E
	cd -
done
