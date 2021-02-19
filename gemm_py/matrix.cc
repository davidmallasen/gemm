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
    // TODO: More sanity checks

    // Extract raw pointers
    int* c = (int*) c_buffer.ptr;
    int* a = (int*) a_buffer.ptr;
    int* b = (int*) b_buffer.ptr;

    gemm(c_buffer.shape[0], c, a, b);
}

PYBIND11_MODULE(matrix, m)
{
    m.def("gemm", &gemm_wrapper, py::arg("c").noconvert(true),
                                 py::arg("a").noconvert(true),
                                 py::arg("b").noconvert(true));
}            
