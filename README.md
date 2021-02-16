# gemm
General matrix multiplication

## Create gemm shared library
~~~
gcc -fPIC -shared -o libmatrix.so matrix.c
~~~

## Create gemm executable in fortran/c
~~~
mkdir build && cd build
cmake ..
make
~~~
To execute run `./bin/gemm_test.out`.
