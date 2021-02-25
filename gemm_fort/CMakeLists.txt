cmake_minimum_required(VERSION 3.9)

project(gemm VERSION 1.0
             DESCRIPTION "General matrix multiply"
             LANGUAGES Fortran)

set(CMAKE_Fortran_COMPILER gfortran)

add_executable(gemm_test.out
    matrix.f90
)

# Find libmatrix shared library
find_library(MATRIX_LIBRARY
    NAMES matrix
    HINTS ../gemm_c/
)
if (MATRIX_LIBRARY)
    target_link_libraries(gemm_test.out PRIVATE ${MATRIX_LIBRARY})
else()
    message(FATAL_ERROR "Cannot find libmatrix.so")
endif()

target_include_directories(gemm_test.out PRIVATE ../gemm_c/)

set_target_properties(gemm_test.out
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "bin/"
    LINKER_LANGUAGE Fortran
)

install(TARGETS gemm_test.out DESTINATION bin)
