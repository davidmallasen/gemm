module matrix
    implicit none
    
    type matrix_t
        real, dimension(:,:), allocatable   :: mat
        integer                             :: d1
        integer                             :: d2
    contains
        procedure, pass(this) :: init => matrix_init
        procedure, pass(this) :: free => matrix_free
        procedure, pass(this) :: multiply => matrix_multiply
        generic :: operator(*) => multiply
    end type matrix_t

contains

    ! Initialize a matrix
    subroutine matrix_init(this, d1, d2)
        class(matrix_t), intent(inout)  :: this
        integer, intent(in)             :: d1
        integer, intent(in)             :: d2

        call matrix_free(this)
        
        allocate(this%mat(d1, d2))
        this%d1 = d1
        this%d2 = d2
    end subroutine matrix_init

    !Free a matrix
    subroutine matrix_free(this)
        class(matrix_t), intent(inout) :: this

        if (allocated(this%mat)) then
            deallocate(this%mat)
        end if
        this%d1 = 0
        this%d2 = 0
    end subroutine matrix_free

    ! General matrix multiply
    function matrix_multiply(this, b) result(c)
        class(matrix_t), intent(in) :: this
        type(matrix_t), intent(in)  :: b
        type(matrix_t) :: c

        integer :: i, j, k

        call c%init(this%d1, b%d2)

        do i = 1, c%d1
            do j = 1, c%d2
                c%mat(i, j) = 0.0
                do k = 1, this%d2
                    c%mat(i, j) = c%mat(i, j) + this%mat(i, k) * b%mat(k, j)
                end do
            end do
        end do
    end function matrix_multiply
    
end module matrix

program gemm_test
    use matrix
    implicit none 

    type(matrix_t) :: A, B, C 

    call A%init(2, 2) 
    call B%init(2, 2) 
    call C%init(2, 2)

    ! Fill A, B with data
    A%mat(1, 1) = 1
    A%mat(1, 2) = 0
    A%mat(2, 1) = 0
    A%mat(2, 2) = 1

    B%mat(1, 1) = 2 
    B%mat(1, 2) = 0
    B%mat(2, 1) = 0
    B%mat(2, 2) = 1

    C = A * B
    
    write(*,*) 'A: ', A%mat
    write(*,*) 'B: ', B%mat
    write(*,*) 'C: ', C%mat
end program gemm_test
