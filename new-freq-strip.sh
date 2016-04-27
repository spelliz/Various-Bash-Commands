if [ -d freq ]; then FILES=$(echo ./freq/*.chk); else FILES=$(echo *.chk); fi

NAME=$(basename $FILES .chk)

/software/gaussian/g09/freqchk $FILES -o freq_tmp.dat y

TEXT=$(grep "ir-frequency" freqchk.scr | cut -d' ' -f 3 | tr '\n' ',' | sed 's/,$//') 

echo "$FILES = [$TEXT]" >> frequencies.dat

rm freqchk.ent  freqchk.scr freq_tmp.dat

#bash ~/bin/info.sh > ${NAME%"-p2"}.info
