sed -n -i '/#VALUE!/!p' energies.txt
sed -n -i '/#DIV\/0!/!p' energies.txt
sed -i 's/#N\/A/\[\]/g' energies.txt
sed -i 's#\[-[0-9]*.[0-9]*,#[#g' energies.txt

