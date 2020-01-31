#!/usr/bin/env python

def array_rotation(A, K):

    
    X = len(A) - 1

    if X == -1:
        return []

    for i in range(K):
        add_it = A.pop(X)
        A = [add_it] + A
    return A


array_rotation([], 4)