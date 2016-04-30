module rnd_num

  implicit none

  integer, parameter :: dp=selected_real_kind(15,300)

  private

  ! Ensure only desired functions are in scope.
  public :: rnd

  contains

    !-----------------------------------!
    ! Random number gen
    !-----------------------------------!
    ! Return a random number (real,kind=dp) in the range [0,1].
    function rnd()
      implicit none
      integer :: i
      real (kind=dp) :: rnd
      call system_clock(i)
      call random_seed(i)
      call random_number(rnd)
    end function rnd

end module rnd_num
