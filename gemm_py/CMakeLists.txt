cmake_minimum_required(VERSION 3.4...3.18)
project(gemm)

add_subdirectory(pybind11)
pybind11_add_module(matrix matrix.cc)

# Find libmatrix shared library
find_library(MATRIX_LIBRARY
    NAMES matrix
    HINTS ../gemm_c/
)
if (MATRIX_LIBRARY)
    target_link_libraries(matrix PRIVATE ${MATRIX_LIBRARY})
else()
    message(FATAL_ERROR "Cannot find libmatrix.so")
endif()

target_include_directories(matrix PRIVATE ../gemm_c/)

target_compile_options(matrix PRIVATE -g -Wall -O3)
