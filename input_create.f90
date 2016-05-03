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
  integer, dimension(3,3,3) :: cube
  real (kind=dp) :: r,u,v,w,delta
  !---------------------------------------------!
  ! Open file that we will output our unit cell
  ! too. Ideally we will read in a parameter file
  ! that will contain details about how other elements
  ! are set up (i.e. what k_point_spacing we want).
  !---------------------------------------------!
  output_file = 20
  open(file='MgO.cell',unit=output_file,status='replace',form='formatted')

  !-------------------------!
  ! First output the Lattice_cart set-up details.
  !-------------------------!
  write(output_file,*) '%BLOCK LATTICE_CART'
  write(output_file,*) '   4.2000000000    0.0000000000    0.0000000000'
  write(output_file,*) '   0.0000000000    4.2000000000    0.0000000000'
  write(output_file,*) '   0.0000000000    0.0000000000    4.2000000000'
  write(output_file,*) '%ENDBLOCK LATTICE_CART'
  write(output_file,*) ''

  !-------------------------!
  ! Atom positions.
  !-------------------------!
  ! We want to be able to distribute atoms randomly into their allowed locations
  ! for the unit cell. We also want to be able to expand the unit cell, and so
  ! need to consider the ability to change the atom locations.


  !=========================
  ! SEED ATOM TYPES
  !=========================
  ! Here we will loop over the cube array and seed what type of atoms can be placed
  ! in the available locations.
  ! 1 = O
  ! 2 = Mg/Ca
  ! The atom_kind variable will flip sign to alternate atom types can be placed.
  print*, '!===================================!'
  print*, '! Populating cube(3,3,3) with atoms !'
  print*, '!===================================!'
  write(output_file,*) '%BLOCK POSITIONS_FRAC'
  ! Set first atom placed to oxygen
  atom_kind = 1

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
  print*, '!-------------------------!'

  !=========================
  ! WRITE ATOMS
  !=========================
  ! Here we will use the seeded cube to write out the atoms and their location
  ! vectors within the cube (u,v,w).
  !-------------------------
  print*, "!=========================!"
  print*, "! Writing atoms...        !"
  print*, "!-------------------------!"
  print*, "! Atom, u, v, w           !"
  print*, "!-------------------------!"
  ! Set the distance between atom vectors
  delta = 0.25
  ! First set the initial location to origin
  u = 0.0_dp
  v = 0.0_dp
  w = 0.0_dp
  ! and the atom type counters to zero
  Mg = 0
  Ca = 0
  ! Then loop over all locations and write the atom to the file.
  do k=1,3
     do j=1,3
        do i=1,3
           ! Check what type of atom can be placed then write to file.
           if (cube(i,j,k) == 1) then
              write(output_file,*) '   O',u,v,w
              print*, '   O',u,v,w
           else
              ! Generate random number to be used as a conditional for the
              ! selection of the atom (Mg,Ca). Range [0,1]
              r = rnd()
              ! Check this random numuber and choose an atom to write
              ! to file. Update the counters for each atom.
              if (r >= 0.5_dp) then
                 write(output_file,*) '   Mg',u,v,w
                 print*, '   Mg',u,v,w
                 Mg = Mg + 1
              else
                 write(output_file,*) '   Ca',u,v,w
                 print*, '   Ca',u,v,w
                 Ca = Ca + 1
              end if
           end if
           ! Update u location
           u = u + delta
        end do
        ! Update v location
        v = v + delta
        u = 0.0_dp
     end do
     ! Update w location
     w = w + delta
     v = 0.0_dp
  end do
  write(output_file,*)  '%ENDBLOCK POSITIONS_FRAC'
  write(output_file,*) ''
  print*, '!-------------------------!'
  !-----------------------------------!

  ! Check the ratio of Ca atoms and output it to the user.
  Print*, 'Ratio for Ca:', real(Ca,kind=dp)/12.0_dp


  !-------------------------!
  ! Next output the remaining details.
  !-------------------------!
  write(output_file,*) ''
  write(output_file,*) 'kpoints_mp_grid 3 3 3'
  write(output_file,*) ''
  write(output_file,*) 'symmetry_generate'
  write(output_file,*) ''
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
