arr=($(find . -type d -printf '%P\n' | grep -ve "LOGFILES" -ve "freq" -ve "stable" -ve "run*" -ve "NOT_NEEDED"))

for g in "${arr[@]}"; do
       [ -d $g ] && cd $g
        echo "$g"

        FILES=$(find . -type f -iname "*.chk" -printf '%P\n' | grep -ve "run*" -ve "LOGFILES" -ve "NOT_NEEDED" | grep "p2")

        if [$FILES = ""]; then FILES=$(echo *.chk); fi

        for i in ${FILES[@]}; do

                NAME=$(basename $i .chk)

                /software/gaussian/g09/freqchk $i -o freq_tmp.dat y

                TEXT=$(grep "ir-frequency" freqchk.scr | cut -d' ' -f 3 | tr '\n' ',' | sed 's/,$//') 

                echo "$i = [$TEXT]" >> frequencies.dat

                rm freqchk.ent  freqchk.scr freq_tmp.dat

        done

        bash ~/bin/info-freq.sh > $g.info

        cd -
done

