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

%macro haa 0        ;hex ascii adjust
    mov bl,al
    and bl,0FH
    cmp bl,09H
        jl not_alphabet
    add bl,07H
    not_alphabet : 
        add bl,30H
    mov [rdi],bl
    inc rdi
%endmacro

section .data
    crlf db '',10

    msg1 db "Enter the String:         "
    msg1_len equ $-msg1
    
    msg2 db "The Length of String is : "
    msg2_len equ $-msg2

section .bss
    strin resb 10000H
    len resb 10H
    global _start

section .text
_start:

    write msg1, msg1_len
    write crlf, 1
    read strin, 10000H

    dec rax
    mov rdi, len
    mov rcx, 10H

    over_all_digits:
        rol rax,04H
        haa
        loop over_all_digits

    mov rcx,10H
    mov rbx,len
    discard_zeros:
        cmp byte[rbx],'0'
        jnz out_of_loop
        inc rbx
        dec rcx
        jnz discard_zeros
        
    out_of_loop:
        add rcx,1H
        write msg2, msg2_len
        write rbx,rcx
        write crlf,1

    exit