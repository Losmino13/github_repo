#!/usr/bin/env python

#https://app.codility.com/programmers/lessons/2-arrays/odd_occurrences_in_array/

from array import *
def solution(A):
    #print (A)

    if len(A) == 1:
        return A[0]
    
    A.sort()
    #print(A)
    for i in range(0,len(A),2):
        #print(i)
        j = i + 1
        if j == len(A):
            #print(A[i])
            return A[i]
        if (A[i] == A[i+1]):
            continue
        else:
            #print(A[i])
            return A[i]


#solution([10])
solution([9, 3, 9, 3, 9])