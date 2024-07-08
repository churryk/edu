#! /usr/bin/python3

import os
import sys
import random

os.getcwd()
os.makedirs('vec_test', exist_ok=True)

file_o_data_s	= './vec_test/o_data_s.vec'
file_o_carry    = './vec_test/o_carry.vec'
file_i_data_a   = './vec_test/i_data_a.vec'
file_i_data_b   = './vec_test/i_data_b.vec'
file_i_carry    = './vec_test/i_carry.vec'

with open(file_o_data_s, 'w') as fh_o_data_s, \
     open(file_o_carry , 'w') as fh_o_carry, \
     open(file_i_data_a, 'w') as fh_i_data_a, \
     open(file_i_data_b, 'w') as fh_i_data_b, \
     open(file_i_carry , 'w') as fh_i_carry:

    simcycle    = 10
    bit         = 32 

    for i in range(simcycle):
        min_int, max_int = 0, (1 << bit) - 1
        int_a = random.randint(min_int, max_int)
        int_b = random.randint(min_int, max_int)
        int_c = random.randint(min_int, 1)
        int_sum = int_a + int_b + int_c

        bin_a = format(int_a, f'0{bit}b')
        bin_b = format(int_b, f'0{bit}b')
        bin_c = format(int_c, '01b')
        bin_sum = format(int_sum, f'0{bit+1}b')

        print(f'--------------------------------------------------')
        print(f'Iteration: {i}')
        print(f'--------------------------------------------------')
        print(f'A   : {bin_a.rjust(33)}')
        print(f'B   : {bin_b.rjust(33)}')
        print(f'C   : {bin_c.rjust(33)}')
        print(f'SUM : {bin_sum.rjust(33)}')
        print(f'--------------------------------------------------')

        fh_o_data_s.write(bin_sum[-bit:] + '\n')
        fh_o_carry.write(bin_sum[0] + '\n')
        fh_i_data_a.write(bin_a + '\n')
        fh_i_data_b.write(bin_b + '\n')
        fh_i_carry.write(bin_c + '\n')





