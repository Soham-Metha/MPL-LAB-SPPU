%include 'macros.asm'

section .data
menu_msg:
    db  0x0A
    db  "1. Addition        ",0x0A
    db  "2. Subtraction     ",0x0A
    db  "3. Multiplication  ",0x0A
    db  "4. Division        ",0x0A
    db  "5. Shift left      ",0x0A
    db  "6. Shift right     ",0x0A
    db  "Enter your choice : "
menu_msg_len: equ $-menu_msg
result_message      db  "Result : "
result_message_len  equ $-result_message

num1  dq  20H
num2  dq  10H

section .bss

    choice resb 1
    buffer resb 10H

section .text

menustart:
    CALL    display_int

    read    buffer, 10H

    MOV qword[buffer], 0
_start:

    print   menu_msg, menu_msg_len
    read    choice,   1

    CMP byte[choice], '7'
    JGE end

    print result_message, result_message_len

    PUSH menustart

    cmp byte[choice], '1'
    jz  l1

    cmp byte[choice], '2'
    jz  l2

    cmp byte[choice], '3'
    jz  l3

    cmp byte[choice], '4'
    jz  l4

    cmp byte[choice], '5'
    jz  l5

    cmp byte[choice], '6'
    jz  l6

end:
exit

l1:
    MOV RAX, [num1]
    ADD RAX, qword[num2]
RET

l2:
    MOV RAX, [num1]
    SUB RAX, qword[num2]
RET

l3:
    MOV  RAX, [num1]
    IMUL qword[num2]
RET

l4:
    MOV RDX, 0
    MOV RAX, [num1]
    IDIV qword[num2]
RET

l5:
    MOV RAX, [num1]
    SHL RAX, 1
RET

l6:
    MOV RAX, [num1]
    SHR RAX, 1
RET

display_int:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 10H                              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print buffer, 10H                         ; print result
RET