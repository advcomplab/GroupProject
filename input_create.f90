program create_input
  !---------------------------------------------!
  ! This program will create a random MgO/CaO s-!
  ! plit for a 2X2 unit cell FCC. This will be  !
  ! used as an input file for CASTEP to calcula-!
  ! te ground state energies for the percentage  !
  ! split.                                      !
  !                                             !
  !---------------------------------------------!
  implicit none

  integer, parameter :: dp=selected_real_kind(15,300)
  integer :: output_file

  !---------------------------------------------!
  ! Open file that we will output our unit cell
  ! too. Ideally we will read in a parameter file
  ! that will contain details about how other elements
  ! are set up (i.e. what k_point_spacing we want).
  !---------------------------------------------!
  output_file = 20
  open(file='input_file.cell',unit=output_file,status='replace',form='formatted')

  !-------------------------!
  ! First output the Lattice_cart set-up details.
  !-------------------------!
  write(output_file,*) '%BLOCK LATTICE_CART'
  write(output_file,*) '4.2000000000    0.0000000000    0.0000000000'
  write(output_file,*) '0.0000000000    4.2000000000    0.0000000000'
  write(output_file,*) '0.0000000000    0.0000000000    4.2000000000'
  write(output_file,*) '%ENDBLOCK LATTICE_CART'

  !-------------------------!
  ! Atom positions.
  !-------------------------!
  ! We want to be able to distribute atoms randomly into their allowed locations
  ! for the unit cell. We also want to be able to expand the unit cell, and so
  ! need to consider the ability to change the atom locations. 

  write(output_file,*) '%BLOCK POSITIONS_FRAC'
  O    0.5000000000    0.5000000000    0.5000000000
  O    0.5000000000    0.0000000000    0.0000000000
  O    0.0000000000    0.5000000000    0.0000000000
  O    0.0000000000    0.0000000000    0.5000000000
  Mg    0.0000000000    0.0000000000    0.0000000000
  Mg    0.0000000000    0.5000000000    0.5000000000
  Mg    0.5000000000    0.0000000000    0.5000000000
  Mg    0.5000000000    0.5000000000    0.0000000000
  %ENDBLOCK POSITIONS_FRAC


  !-------------------------!
  ! Next output the remaining details.
  !-------------------------!

  write(output_file,*) 'kpoints_mp_spacing 3 3 3'

  write(output_file,*) 'symmetry_generate'

  write(output_file,*) '%BLOCK CELL_CONSTRAINTS'
  write(output_file,*) '       1       1       1'
  write(output_file,*) '       0       0       0'
  write(output_file,*) '%ENDBLOCK CELL_CONSTRAINTS'


  !-------------------------!
  ! Remaining details are not output until we have a working system.
  !-------------------------!

  ! The following section is commented out; CASTEP will generate these files for you
  ! the first time you use the appropriate element. You can then uncomment this block
  ! to speed up the initial stages of the calculation. 
  !%BLOCK SPECIES_POT
  !       O   O_OTF.usp
  !      Mg  Mg_OTF.usp
  !      Ca  Ca_OTF.usp
  !%ENDBLOCK SPECIES_POT

end program create_input
