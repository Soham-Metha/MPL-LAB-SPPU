%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    msg1:
        db  "Enter Data : "
    msg1_len: equ $-msg1

    msg2:
        db  "Array Data : "
    msg2_len: equ $-msg2

    count:
       db  05H

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    numarr:
        resb 55H

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    MOV RBP, numarr
    take_input:
        print msg1, msg1_len
        read  RBP,  11H
        ADD   RBP,  11H
        DEC   byte[count]
    JNZ take_input

    MOV byte[count], 05H
    MOV RBP, numarr
    print_output:
        print msg2, msg2_len
        print RBP,  11H
        ADD   RBP,  11H
        DEC   byte[count]
    JNZ print_output
    
exit