array1=($(find . -mindepth 1  -maxdepth 1 -type f -name "*.gjf" -printf '%P\n'))

for file in "${array1[@]}"; do

	CM=$( grep -v [a-zA-Z] $file | sed '/^\s*$/d' | head -1 )
	sed -i "/$CM/,/\(@\|notatom\)/{//!d}"  $file

done
