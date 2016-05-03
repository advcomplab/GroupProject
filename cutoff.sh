#!/bin/bash




x=200


while [ $x -le 550 ]
do

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

mpirun -np 1 castep.mpi MgO &



echo "$x     " "grep 'Final energy, E" MgO.castep

x=x+50



done
