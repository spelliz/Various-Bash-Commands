#!/bin/bash
#
#PBS -N FORMCHK
#PBS -q workq
#PBS -l select=1:ncpus=1:mem=2gb:interconnect=mx,walltime=72:00:00
#PBS -j oe

cd $PBS_O_WORKDIR

echo $PBS_O_WORKDIR

start_size=$( du -scB KB | grep total | grep -o '[0-9]*kB' )

arr1=( $(find . -iname "*.chk" ) )

for FILE1 in ${arr1[@]}; do
        /software/gaussian/g09/formchk -3 $FILE1
        rm -v $FILE1
done

finish_size=$( du -scB KB | grep total | grep -o '[0-9]*kB' )

space_saved_tmp=$(echo ${start_size%kB} - ${finish_size%kB} |bc -l)
space_saved=$(echo $space_saved_tmp / 1000000 | bc -l | sed -e 's/[0]*$//')
echo "FINISHED"
echo 'Space saved = '$space_saved'GB'

