#!/bin/bash




x=200



echo '#Cut-off Energy' 'Final Energy'> finalE.dat

while [ $x -le 550 ]
do

#Writes the parameters for the particular cut-off energy value

echo "comment            : MgO
task               : SinglePoint
xc_functional      : LDA
spin_polarized     : false
cut_off_energy     : $x eV
grid_scale         : 2.0000000000


elec_energy_tol    : 0.0000001
max_scf_cycles     : 60

fix_occupancy      : false

calculate_stress   : true 


opt_strategy       : speed
page_wvfns         :   0


metals_method      : dm
mixing_scheme      : pulay
smearing_width     : 0.2
mix_history_length : 30" > MgO.param

mpirun -np 1 castep.mpi MgO

#Gets the number of the the line which has the final calculated energy

line=$(grep -n "Total energy corrected" "MgO.castep" | cut -d : -f 1 | tail -1)

#Grabs the energy value

energy=$(awk 'FNR == '$line' {print $9}' 'MgO.castep')

echo 'line=' $line
echo $x

#Writes data out to file

echo $x "          " $energy >> finalE.dat

#Iterates the cut-off energy

x=`expr $x + 50`


done
