cmake_minimum_required(VERSION 3.9)

project(gemm VERSION 1.0
             DESCRIPTION "General matrix multiply"
             LANGUAGES C Fortran)

set(CMAKE_C_COMPILER gcc)
set(CMAKE_Fortran_COMPILER gfortran)

add_executable(gemm_test.out
    ../gemm_c/matrix.c
    matrix.f90
)

set_target_properties(gemm_test.out
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "bin/"
    LINKER_LANGUAGE Fortran
)

install(TARGETS gemm_test.out DESTINATION bin)
