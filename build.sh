#!/bin/bash
#file name prefix
prefix=s24ce003_practical_

clear &&
#build object file
nasm -f elf64 $prefix$1.asm &&

#create executable
ld $prefix$1.o -o $prefix$1.out &&

#run executable
./$prefix$1.out &&

#clean the trash
rm $prefix$1.out $prefix$1.o