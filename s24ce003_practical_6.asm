%include 'macros.asm'

section .data

    menu_msg:
        db  0x0A,0x0A
        db  "-------------------",0x0A
        db "1. HEX to BCD       ",0x0A
        db "2. BCD to HEX       ",0x0A
        db "3. EXIT             ",0x0A
        db  "-------------------",0x0A
        db "Your Choice : "
    
    menu_msg_len: equ $-menu_msg
    In_msg:
        db "Enter Input: "
    in_msg_len: equ $-In_msg

    invalid_msg db "Invalid input!", 0xA
    Out_msg:
        db "Result: "
    out_msg_len: equ $-Out_msg

section .bss

    choice:
        resb 2
    input:
        resb 6
    output:
        resb 6

section .text

_start:


exit