%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    msg1     db  "Enter String :            "
    msg1_len equ $-msg1
    
    msg2     db  "Length of String : "
    msg2_len equ $-msg2

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    strin  resb 10000H
    strlen resb 10H

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    println dash_break, dash_break_len
    print   msg1,       msg1_len
    read    strin,      10000H

    DEC RAX
    MOV RDI, strlen
    MOV RCX, [ qword_digit_count ]

    over_all_digits:
        ROL RAX, 04H
        hex_ascii_adjust 
    LOOP over_all_digits

    println dash_break, dash_break_len
    print   msg2,       msg2_len

    MOV     RCX,        [ qword_digit_count ]
    trim    strlen
    println RBX,        RCX
    println dash_break, dash_break_len
exit