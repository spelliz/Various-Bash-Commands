#!/bin/bash      
#PBS -N CATMAP
#PBS -l select=1:ncpus=1:mem=10gb:interconnect=mx,walltime=12:00:00  
#PBS -j oe      
#PBS -r n
#PBS -M spelliz@clemson.edu
#PBS -m ae

source ~/.bash_profile
source ~/.bashrc

cd $PBS_O_WORKDIR  

python mkm_job.py

python ~/bin/table_maker.py production_rate
python ~/bin/table_maker.py coverage
python ~/bin/table_maker.py rate_control
python ~/bin/table_maker.py selectivity_control
python ~/bin/table_maker.py selectivity
python ~/bin/table_maker.py rate_constant
python ~/bin/table_maker.py forward_rate_constant
python ~/bin/table_maker.py reverse_rate_constant
python ~/bin/table_maker.py equilibrium_constant
python ~/bin/table_maker.py directional_rates

arr1=( $(find . -iname "*table.txt" ) )

for FILE1 in ${arr1[@]}; do
        perl -i -ne 'print if ! $a{$_}++' $FILE1
        head -n 1 $FILE1 > ${FILE1%.txt}_short.txt
        tail -n 5 $FILE1 >> ${FILE1%.txt}_short.txt
done

mkdir IMAGES
mv *.pdf IMAGES\

mkdir TABLES
mv *table*.txt TABLES

