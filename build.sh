#!/bin/bash
#file name prefix
prefix=s24ce003_practical_

clear &&
#build object file
nasm -f elf64 $prefix$1.asm

if [[ "$1" == "9" ]]; then
    nasm -f elf64   $prefix$1helper.asm &&
    ld $prefix$1.o  $prefix$1helper.o   -o $prefix$1.out;
else
    ld $prefix$1.o                      -o $prefix$1.out;
fi

#run executable
./$prefix$1.out $2

#clean the trash
rm ./*.out ./*.o