#include "matrix.h"
#include <stdio.h>

void gemm(int n, int* c, int* a, int* b) {
    printf("Matrix multiply in c!\n");

    for(int i = 0; i < n; ++i) {
        for(int j = 0; j < n; ++j) {
            c[i * n + j] = 0;
            for(int k = 0; k < n; ++k) {
                c[i * n + j] += a[i * n + k] * b[k * n + j];
            }
        }
    }
}
