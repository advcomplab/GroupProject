program create_input
  !---------------------------------------------!
  ! This program will create a random MgO/CaO s-
  ! plit for a 2X2 unit cell FCC. This will be  
  ! used as an input file for CASTEP to calcula-
  ! te ground state energies for the percentage 
  ! split.                                      
  !                                             
  !---------------------------------------------!

  ! Include our dependant random number generator.
  use rnd_num
  implicit none

  integer, parameter :: dp=selected_real_kind(15,300)
  integer :: output_file,i
  real (kind=dp), dimension(3) :: loc_1,loc_2,loc_3,loc_4
  real (kind=dp), dimension(4:3) :: locations
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

  ! Firs write the Oxygen atom positions.
  write(output_file,*) '%BLOCK POSITIONS_FRAC'
  write(output_file,*) 'O    0.5000000000    0.5000000000    0.5000000000'
  write(output_file,*) 'O    0.5000000000    0.0000000000    0.0000000000'
  write(output_file,*) 'O    0.0000000000    0.5000000000    0.0000000000'
  write(output_file,*) 'O    0.0000000000    0.0000000000    0.5000000000'

  ! Set our allowed locations.
  locations(1,3) = (/0.0000000000,    0.0000000000,    0.0000000000/)
  locations(2,3) = (/0.0000000000,    0.5000000000,    0.5000000000/)
  locations(3,3) = (/0.5000000000,    0.0000000000,    0.5000000000/)
  locations(4,3) = (/0.5000000000,    0.5000000000,    0.0000000000/)
  ! Next we need to randomise the atoms in the possile positions available. 
  
  do i=1,4 
     print*, rnd()
     write(output_file,*) 'Mg',locations(i,:)
  end do

  ! Mg    0.0000000000    0.0000000000    0.0000000000
  ! Mg    0.0000000000    0.5000000000    0.5000000000
  ! Mg    0.5000000000    0.0000000000    0.5000000000
  ! Mg    0.5000000000    0.5000000000    0.0000000000

  write(output_file,*)  '%ENDBLOCK POSITIONS_FRAC'


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
