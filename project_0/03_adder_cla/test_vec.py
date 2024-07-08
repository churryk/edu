#! /usr/bin/python3

import os
import sys
import random

os.getcwd()
os.system('mkdir -p vec')

file_o_data_s	= './vec_test/o_data_s.vec'
file_o_carry    = './vec_test/o_carry.vec'
file_i_data_a   = './vec_test/i_data_a.vec'
file_i_data_b   = './vec_test/i_data_b.vec'
file_i_carry    = './vec_test/i_carry.vec'

fh_o_data_s		= open(file_o_data_s,	'w')
fh_o_carry      = open(file_o_carry,	'w')
fh_i_data_a     = open(file_i_data_a,	'w')
fh_i_data_b     = open(file_i_data_b,	'w')
fh_i_carry      = open(file_i_carry,	'w')

simNum      = 10
bitWidth    = 32 

for n in range(simNum):
	intMIN, intMAX = 0, pow(2,bitWidth)-1
	intA    = random.randint(intMIN, intMAX)
	intB    = random.randint(intMIN, intMAX)
	intC    = random.randint(intMIN, 1)
	intSUM  = intA + intB + intC
	binA	= bin(intA	)[2:].rjust(bitWidth,'0')
	binB	= bin(intB  )[2:].rjust(bitWidth,'0')
	binC	= bin(intC  )[2:].rjust(1, '0')
	binSUM  = bin(intSUM)[2:].rjust(bitWidth+1,'0')
	print('--------------------------------------------------')
	print('Iteration: %s'%(n))
	print('--------------------------------------------------')
	print('A   : %33s'%(binA))
	print('B   : %33s'%(binB))
	print('C   : %33s'%(binC))
	print('SUM : %33s'%(binSUM))
	print('--------------------------------------------------')
	fh_o_data_s.write(binSUM[1:bitWidth+1] + '\n')
	fh_o_carry .write(binSUM[0] + '\n')
	fh_i_data_a.write(binA + '\n')
	fh_i_data_b.write(binB + '\n')
	fh_i_carry .write(binC + '\n')
fh_o_data_s.close()
fh_o_carry .close()
fh_i_data_a.close()
fh_i_data_b.close()
fh_i_carry .close()





