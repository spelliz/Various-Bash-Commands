arr1=( $(find . -iname "*.txt" ) )

for FILE1 in ${arr1[@]}; do
	perl -i -ne 'print if ! $a{$_}++' $FILE1
        head -n 1 $FILE1 > ${FILE1%.txt}_short.txt
	tail -14 $FILE1 >> ${FILE1%.txt}_short.txt
done
