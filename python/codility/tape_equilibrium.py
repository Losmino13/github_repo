#!/usr/bin/env python

#https://app.codility.com/programmers/lessons/3-time_complexity/tape_equilibrium/

def solution(A):

    P = len(A)
    dminimum = 10000000000000000

    for i in range(1,P):
        
        sum1 = sum(A[:i])
        sum2 = sum(A[i:])
        dmin = abs(sum1 - sum2)
        if dmin < dminimum :
            dminimum = dmin
        #print (dminimum)       
        #print (A[:i])
        #print (A[i:])

    print(dminimum)
    return dminimum

solution([3, 221])