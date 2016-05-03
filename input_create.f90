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
  integer :: output_file,i,j,k,Mg,Ca,atom_kind
  real (kind=dp), dimension(4,3) :: locations
  integer, dimension(3,3,3) :: cube
  real (kind=dp) :: r,u,v,w
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

  !=========================
  ! SEED ATOM TYPES
  !=========================
  ! Here we will loop over the cube array and seed what type of atoms can be placed
  ! in the available locations.
  ! 1 = O
  ! 2 = Mg/Ca
  ! The atom_kind variable will flip sign to alternate atom types can be placed.

  ! Set first atom placed to oxygen
  atom_kind = 1
  print*, 'Populating cube(3,3,3) with atoms.'
  do k=1,3
     do j=1,3
        do i=1,3
           ! Check what type of atom can be placed and update
           ! the location.
           if (atom_kind >= 1) then
              cube(i,j,k) = 1
           else
              cube(i,j,k) = 2
           end if
           ! Change the kind f atom placed for the next element
           atom_kind = -atom_kind
        end do
     end do
  end do
  print*, 'Finished writing CUBE array.'

  !=========================
  ! WRITE ATOMS
  !=========================
  ! Here we will use the seeded cube to write out the atoms and their location
  ! vectors within the cube (u,v,w).
  !-------------------------
  ! First set the initial location to origin
  u = 0.0_dp
  v = 0.0_dp
  w = 0.0_dp
  ! Then loop over all locations and write the atom to the file.
  do k=1,3
     do j=1,3
        do i=1,3
           ! Check what type of atom can be placed then write to file.
           if (cube(i,j,k) == 1) then
              print*, 'O',u,v,w
           else
              print*, 'Mg',u,v,w
           end if
           ! Update u location
           u = u + 0.5_dp
        end do
        ! Update v location
        v = v + 0.5_dp
        u = 0.0_dp
     end do
     ! Update w location
     w = w + 0.5_dp
     v = 0.0_dp
  end do



  ! Set our allowed locations
  locations = 0

  locations(2,2) = 0.5_dp
  locations(2,3) = 0.5_dp

  locations(3,1) = 0.5_dp
  locations(3,3) = 0.5_dp

  locations(4,1) = 0.5_dp
  locations(4,2) = 0.5_dp

  ! Next we need to randomise the atoms in the possile positions available.
  ! First set our counters to zero.
  Mg = 0
  Ca = 0
  ! Then loop over atom positions and randomly assign a Mg/Ca atom.
  do i=1,4
     if (rnd() <= 0.5_dp) then
        write(output_file,*) 'Mg', locations(i,:)
        Mg = Mg + 1
     else
        write(output_file,*) 'Ca', locations(i,:)
        Ca = Ca + 1
     end if
  end do

  Print*, 'Ratio for Ca:', real(Ca,kind=dp)/4.0_dp
  write(output_file,*)  '%ENDBLOCK POSITIONS_FRAC'
  !-----------------------------------!


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
