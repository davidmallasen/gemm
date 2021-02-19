import numpy as np
from matrix import gemm


def main():
    c = np.zeros((10, 10), np.int32)
    c_np = np.zeros((10, 10), np.int32)

    # 10x10 matrix -> assign random integers from 0 to 10
    a = np.random.randint(0, 10, (10, 10), np.int32)
    b = np.random.randint(0, 10, (10, 10), np.int32)
    
    gemm(c, a, b)

    # Numpy check
    np.matmul(a, b, c_np)

    if (c == c_np).all():
        print("Correct result!")
    else:
        print("Wrong result!")


if __name__ == "__main__":
    main()

