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

section .bss
    global _start

section .text
_start:

    exit