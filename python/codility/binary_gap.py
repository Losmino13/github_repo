#!/usr/bin/env python

#https://app.codility.com/programmers/lessons/1-iterations/binary_gap/

def binary_gap(number):

    binary_num = bin(number)
    #print (f"{binary_num}")
    binary_number = binary_num[2:]
    print (f"{binary_number}")
    #binary_array=binary_number.split()
    binary_array=list(binary_number)
    #print(binary_array)
    
    index_od_1 = []
    br = 1
    for i in binary_array:
        if i == '1':
            index_od_1.append(br)
            br = br + 1
        else:
            br = br + 1
    #print(index_od_1)
    
    if (len(index_od_1) == 1):
      print("No binary gap")
      return 0

    dmax = 0
    for i in range(len(index_od_1)):
        start = index_od_1[i]
        j = i + 1
        if j == len(index_od_1):
            break
        end = index_od_1[j]
        potential_max = end - start
        if potential_max > dmax:
            dmax = potential_max  
    print(dmax-1)

binary_gap(711155555)