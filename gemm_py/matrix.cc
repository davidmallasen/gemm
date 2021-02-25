#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>     // Include header that supports Numpy arrays

extern "C" {
    #include "matrix.h"
}

namespace py = pybind11;

void gemm_wrapper(py::array_t<int, py::array::c_style | py::array::forcecast> py_c,
                  py::array_t<int, py::array::c_style | py::array::forcecast> py_a,
                  py::array_t<int, py::array::c_style | py::array::forcecast> py_b) {
    // Request for buffer information
    py::buffer_info c_buffer = py_c.request();
    py::buffer_info a_buffer = py_a.request();
    py::buffer_info b_buffer = py_b.request();

    // Check dim
    if (c_buffer.ndim != 2 || b_buffer.ndim != 2 || a_buffer.ndim != 2) {
        throw std::runtime_error("Error: dimension of matrix should be 2");
    }

    // Check size match
    if (a_buffer.size != b_buffer.size || a_buffer.size != c_buffer.size) {
        throw std::runtime_error("Error: size of A, B and C must match");
    }

    int n = c_buffer.shape[0];

    // Extract raw pointers
    int* c = (int*) c_buffer.ptr;
    int* a = (int*) a_buffer.ptr;
    int* b = (int*) b_buffer.ptr;

    // Allocate memory for the column-major gemm library and assign values
    int* a_ = (int*) malloc(n * n * sizeof(int));
    int* b_ = (int*) malloc(n * n * sizeof(int));
    int* c_ = (int*) malloc(n * n * sizeof(int));
    
    int i, j;
    for(i = 0; i < n; ++i) {
        for(j = 0; j < n; ++j) {
            a_[i + n * j] = a[j + n * i];
            b_[i + n * j] = b[j + n * i];
        }
    }

    gemm(n, c_, a_, b_);

    // Transpose the result back to row-major order and free memory
    for(i = 0; i < n; ++i) {
        for(j = 0; j < n; ++j) {
            c[i + n * j] = c_[j + n * i];
        }
    }

    free(c_);
    free(b_);
    free(a_);
}

PYBIND11_MODULE(matrix, m)
{
    m.def("gemm", &gemm_wrapper, py::arg("c").noconvert(true),
                                 py::arg("a").noconvert(true),
                                 py::arg("b").noconvert(true));
}            
