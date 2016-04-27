arr1=( $(grep -i "galloc:  could not allocate memory." */*.info | cut -f 1 -d "/"))

for file in ${arr1[@]}; do
	cp $file/$file.gjf $PWD
	rm -r $file/
done

