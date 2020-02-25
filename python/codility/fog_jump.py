#!/usr/bin/env python

#https://app.codility.com/programmers/lessons/3-time_complexity/frog_jmp/

def solution(X, Y, D):

    if X == Y:
        return 0
        
    distance = Y - X

    decimal_jumps = distance / D
    if decimal_jumps.is_integer():
        #print (decimal_jumps)
        return int(decimal_jumps)
    number_of_jumps = int(decimal_jumps) + 1
    #print(number_of_jumps)
    return number_of_jumps

solution(10, 100, 30)