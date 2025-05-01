%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    msg1     db  "Enter String :            "
    msg1_len equ $-msg1
    
    msg2     db  "Length of String : "
    msg2_len equ $-msg2

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    strin  resb 100H
    buffer resb 10H

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    print   msg1,  msg1_len
    read    strin, 100H
    print   msg2,  msg2_len

    DEC     RAX
    CALL display_int

exit

;-----------------------------------------------------------------------------------------------------------------------------

display_int:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 10H                              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print buffer, 10H                         ; print result
RET