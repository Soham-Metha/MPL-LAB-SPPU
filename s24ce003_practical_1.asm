%macro read 2        ;standard read
    MOV rsi, %1
    MOV rdx, %2
    MOV rax, 0H
    MOV rdi, 0H
    syscall
%endmacro

%macro write 2        ;standard write
    MOV rsi, %1
    MOV rdx, %2
    MOV rax, 1H
    MOV rdi, 1H
    syscall
%endmacro

%macro exit 0
    MOV rax, 3CH
    MOV rdi, 00H
    syscall
%endmacro

section .data
    crlf db '',10
    msg1 db "Enter the Data : "
    msg1_len equ $-msg1
    msg2 db "The Array Data is : "
    msg2_len equ $-msg2
    count db 05H
    numsize dq 11H

section .bss
    numarr resb 55H
    global _start

section .text
_start:
    MOV rbp,numarr

    take_input:
        write msg1, msg1_len
        write crlf, 1

        read  rbp, [ numsize ]
        ADD rbp, [ numsize ]

        DEC byte[ count ]
    JNZ take_input

    MOV rbp, numarr
    MOV byte[ count ],05H

    print_output:
        write msg2, msg2_len
        write crlf, 1

        write rbp, [ numsize ]
        ADD rbp, [ numsize ]

        DEC byte[ count ]
    JNZ print_output

    exit