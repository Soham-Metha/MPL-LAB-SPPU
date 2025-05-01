%include 'macros.asm'

section .data
add_msg             db  "1. Addition"
add_msg_len         equ $-add_msg
sub_msg             db  "2. Subtraction"
sub_msg_len         equ $-sub_msg
mul_msg             db  "3. Multiplication"
mul_msg_len         equ $-mul_msg
div_msg             db  "4. Division"
div_msg_len         equ $-div_msg
shl_msg             db  "5. Shift left"
shl_msg_len         equ $-shl_msg
shr_msg             db  "6. Shift right"
shr_msg_len         equ $-shr_msg
ask_choice_msg      db  "Enter your choice : "
ask_choice_msg_len  equ $-ask_choice_msg
disp_choice_msg     db  "You Chose : "
disp_choice_msg_len equ $-disp_choice_msg
result_message      db  "Result : "
result_message_len  equ $-result_message

num1  dq  20H
num2  dq  10H

section .bss

    choice resb 1
    buffer resb 10H
    bitcnt resq 1

section .text

menustart:
    CALL    display_int
    printbr
    read    buffer, 10H
    read    buffer, 10H

    clear_screen

    MOV qword[buffer], 0
_start:

    printbr
    println add_msg, add_msg_len
    println sub_msg, sub_msg_len
    println mul_msg, mul_msg_len
    println div_msg, div_msg_len
    println shl_msg, shl_msg_len
    println shr_msg, shr_msg_len
    printbr

    print   ask_choice_msg, ask_choice_msg_len
    read    choice,         1
    printbr

    SUB     byte[choice],    '0'
    print   disp_choice_msg, disp_choice_msg_len
    MOV     RAX,             [choice]
    CALL    display_int

    cmp byte[choice], 1
    jz  l1

    cmp byte[choice], 2
    jz  l2

    cmp byte[choice], 3
    jz  l3

    cmp byte[choice], 4
    jz  l4

    cmp byte[choice], 5
    jz  l5

    cmp byte[choice], 6
    jz  l6

exit

l1:
    print   crlf, 1
    println add_msg, add_msg_len
    printbr result_message, result_message_len
    MOV RAX, [num1]
    ADD RAX, qword[num2]
    
jmp menustart

l2:
    print crlf, 1
    println sub_msg, sub_msg_len
    printbr result_message, result_message_len
    MOV RAX, [num1]
    SUB RAX, qword[num2]
jmp menustart

l3:
    print crlf, 1
    println mul_msg, mul_msg_len
    printbr result_message, result_message_len
    MOV  RAX, [num1]
    IMUL qword[num2]
jmp menustart

l4:
    print crlf, 1
    println div_msg, div_msg_len
    printbr result_message, result_message_len
    MOV RDX, 0
    MOV RAX, [num1]
    IDIV qword[num2]
jmp menustart

l5:
    print crlf, 1
    println shl_msg, shl_msg_len
    printbr

    print result_message, result_message_len
    MOV RAX, [num1]
    SHL RAx, 1
jmp menustart

l6:
    print crlf, 1
    println shr_msg, shr_msg_len
    printbr

    print result_message, result_message_len
    MOV RAX, [num1]
    SHR RAx, 1
jmp menustart

display_int:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, [qword_digit_count]              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    printtr buffer, [qword_digit_count]       ; trim the leading '0's from buffer, and print result
RET