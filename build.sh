#!/bin/bash
#file name prefix
prefix=s24ce003_practical_

clear &&
#build object file

if [[ "$1" == "9" ]]; then
    echo "exp 9"
    nasm -f elf64 s24ce003_practical_9.asm &&
    nasm -f elf64 s24ce003_practical_9helper.asm &&
    ld -o s24ce003_practical_9.out s24ce003_practical_9.o s24ce003_practical_9helper.o ;
else
    nasm -f elf64 $prefix$1.asm
    ld $prefix$1.o -o $prefix$1.out;
fi
#create executable
ld $prefix$1.o -o $prefix$1.out &&

#run executable
./$prefix$1.out

#clean the trash
#rm $prefix$1.out $prefix$1.o