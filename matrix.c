#include "matrix.h"
#include <stdio.h>

void matrix_multiply(int n, int** c, int** a, int** b) {
    printf("Matrix multiply in c!\n");
    printf("n %d", n);
    //printf("Inputs: c %d a %d b %d", c[0][0], a[0][0], b[0][0]);
    for(int i = 0; i < n; ++i) {
        for(int j = 0; j < n; ++j) {
            c[i][j] = 0;
            for(int k = 0; k < n; ++k) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}
