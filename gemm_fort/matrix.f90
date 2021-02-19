module matrix_c
    interface 
        subroutine c_matrix_multiply(n, c, a, b) bind(c, name="gemm")
            use iso_c_binding
            implicit none
            integer(c_int), value :: n
            integer(c_int)        :: c(*)
            integer(c_int)        :: a(*)
            integer(c_int)        :: b(*)
        end subroutine
    end interface
end module

module matrix
    implicit none
    
    type matrix_t
        integer, dimension(:,:), allocatable    :: mat
        integer                                 :: d1
        integer                                 :: d2
    contains
        procedure, pass(this)   :: init => matrix_init
        procedure, pass(this)   :: free => matrix_free
        procedure               :: multiply => matrix_multiply_c   
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
    function matrix_multiply(a, b) result(c)
        type(matrix_t), intent(in) :: a
        type(matrix_t), intent(in) :: b
        type(matrix_t) :: c

        integer :: i, j, k

        call c%init(a%d1, b%d2)

        do i = 1, c%d1
            do j = 1, c%d2
                c%mat(i, j) = 0.0
                do k = 1, a%d2
                    c%mat(i, j) = c%mat(i, j) + a%mat(i, k) * b%mat(k, j)
                end do
            end do
        end do
    end function matrix_multiply

    ! General matrix multiply in c
    function matrix_multiply_c(a, b) result(c)
        use matrix_c
        use iso_c_binding
        class(matrix_t), intent(in) :: a
        type(matrix_t), intent(in) :: b
        type(matrix_t) :: c

        call c%init(a%d1, b%d2)

        call c_matrix_multiply(a%d1, c%mat, a%mat, b%mat)
    end function matrix_multiply_c
    
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
    A%mat(1, 2) = 2
    A%mat(2, 1) = 3
    A%mat(2, 2) = 4

    B%mat(1, 1) = 5 
    B%mat(1, 2) = 6
    B%mat(2, 1) = 7
    B%mat(2, 2) = 8

    !| 1 3 |   | 5 7 |   | 23 31 |
    !| 2 4 | x | 6 8 | = | 34 46 |

    C = A * B
    
    write(*,*) 'A: ', A%mat
    write(*,*) 'B: ', B%mat
    write(*,*) 'C: ', C%mat
end program gemm_test
