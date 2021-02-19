#include "matrix.h"
#include <stdio.h>

void gemm(int n, int* c, int* a, int* b) {
    printf("Column-major order matrix multiply in c!\n");

    for(int i = 0; i < n; ++i) {
        for(int j = 0; j < n; ++j) {
            c[i + j * n] = 0;
            for(int k = 0; k < n; ++k) {
                c[i + j * n] += a[i + k * n] * b[k + j * n];
            }
        }
    }
}
