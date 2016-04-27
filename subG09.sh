#!/bin/bash
#
#PBS -N GAUSSIAN
#PBS -q workq
#PBS -l select=1:ncpus=8:mpiprocs=8:mem=14gb:interconnect=mx,walltime=72:00:00
#PBS -l place=scatter
#PBS -j oe
#PBS -r n
#PBS -M spelliz@clemson.edu
#PBS -m ae

cd $PBS_O_WORKDIR

NAME=$(basename $(find . -maxdepth 1 -name "*.gjf") .gjf)
MEM_tmp=`qstat -xf $PBS_JOBID | grep Resource_List.select | grep -o '[0-9]\{1,3\}'gb`
SELECT=`qstat -xf $PBS_JOBID | grep Resource_List.nodect | grep -o '[0-9]'`

let MEM_num=${MEM_tmp%gb}
MEM=$(echo ${MEM_tmp/$MEM_num/$[MEM_num-2]})

# user prepared input file
input=$NAME.gjf

# start

module load gaussian/g09

filename=`basename $input .gjf`

export GAUSS_LFLAGS='-opt "Tsnet.Node.lindarsharg: ssh"'

# prepare a local scratch dirs
nodes=`cat $PBS_NODEFILE`
scratch="/local_scratch/$USER.$PBS_JOBID"
for i in $nodes
do
  ssh $i "mkdir $scratch"
done
export GAUSS_SCRDIR=$scratch

# Augment the input file by the Linda and Shared parallelization
# option
tmpinput=${filename}_tmp.gjf
nodelist=`cat $PBS_NODEFILE | uniq | tr '\n' "," | sed 's|,$||'`
echo "%NProcShared="$OMP_NUM_THREADS >> $tmpinput
if [ $SELECT -ne 1 ]; then
	echo "%LindaWorkers="$nodelist >> $tmpinput
fi
echo "%mem="$MEM >> $tmpinput
echo "%chk="$NAME.chk >> $tmpinput
cat $input >> $tmpinput

# run Gaussian 09
g09 $tmpinput

# rename output file
rm $tmpinput
mv ${filename}_tmp.log ${filename}.log

# clean the local scratch directories
for i in $nodes
do
  ssh $i "rm -r $scratch"
done

echo "FINISH ---------------------"
qstat -xf $PBS_JOBID

rm core.[0-9]*
# end
