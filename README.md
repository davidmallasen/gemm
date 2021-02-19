# General matrix multiplication (gemm)

## Create gemm shared library in c

In directory `gemm_c` run:

~~~
gcc -fPIC -shared -o libmatrix.so matrix.c
~~~

## Create gemm executable in fortran/c

In directory `gemm_fort` run:

~~~
mkdir build && cd build
cmake ..
make
~~~

To execute run `./bin/gemm_test.out`.

## Python matrix extension

For this you will need a python3 environment with numpy installed.

In directory `gemm_py` run:
~~~
mkdir build && cd build
cmake ..
make
cp ../run_matrix.py .
python run_matrix.py
~~~

The python module will be built into the `gemm_py/build/` directory. It is in this directory where you should execute python so that it can find the matrix module.
