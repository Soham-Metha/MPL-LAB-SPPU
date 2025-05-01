%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    msg1:
        db  "Enter String :     "
    msg1_len: equ $-msg1
    
    msg2:
        db  "Length of String : "
    msg2_len: equ $-msg2

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    strin:
        resb 100H
    buffer:
        resb 10H

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    print   msg1,  msg1_len
    read    strin, 100H

    PUSH    RAX-1
    print   msg2,  msg2_len
    POP     RAX
    CALL    display_quad

exit

;-----------------------------------------------------------------------------------------------------------------------------
