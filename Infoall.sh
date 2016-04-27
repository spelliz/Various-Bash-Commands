arr=($(find . -mindepth 1  -maxdepth 1 -type d -printf '%P\n' | grep -v Group*))

for g in "${arr[@]}"; do
       [ -d $g ] && cd "$g"
        echo "$g"
        info.sh > $g.info
	cd -
done

arr2=($(find . -mindepth 2 -maxdepth 2 -type d -name "SPIN" -printf '%P\n'))

for f in "${arr2[@]}"; do
       [ -d $f ] && cd "$f"
        echo "${f/'/SPIN'/s}"
        info.sh > ${f/'/SPIN'/s}.info
        cd -
done

arr3=($(find . -type d -iname "reopt" -printf '%P\n'))

for h in "${arr3[@]}"; do
       [ -d $h ] && cd "$h"
        echo "$h"
        Z=$(basename *.gjf .gjf)
	info.sh > $Z.info
        cd -
done

