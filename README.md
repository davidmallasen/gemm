# General matrix multiplication (gemm)

First clone this repo and update the submodules by running:

~~~
git clone --recurse-submodules https://github.com/davidmallasen/gemm.git
cd gemm
~~~

## Create gemm shared library in c

In directory `gemm_c` run:

~~~
gcc -fPIC -shared -o libmatrix.so matrix.c
~~~

This will create a row-major order matrix multiplication.

## Create gemm executable in fortran/c

In directory `gemm_fort` run:

~~~
mkdir build && cd build
cmake ..
make
~~~

To execute run `./bin/gemm_test.out`.

The result should print `Column-major order matrix multiply in c!` as it is using the local column-major c algorithm.

## Python matrix extension

For this you will need a python3 environment with numpy 1.20 installed. For example using pip you can run at the root of the project:

~~~
python3 -m venv venv
source venv/bin/activate
pip3 install numpy
~~~

In directory `gemm_py` run:

~~~
mkdir build && cd build
cmake ..
make
cp ../run_matrix.py .
python3 run_matrix.py
~~~

The python module will be built into the `gemm_py/build/` directory. It is in this directory where you should execute python so that it can find the matrix module.

The matrix multiplication should print `Row-major order matrix multiply in c!` as it is using the shared library c algorithm. 

## Using a custom gemm shared library in c

In this case you should follow the same header as in `gemm_c/matrix.h`, name the shared library as `libmatrix.so` and copy it to the `gemm_c` directory as `gemm_c/libmatrix.so`.
