%macro read 2        ;standard read
    MOV RSI, %1
    MOV RDX, %2
    MOV RAX, 0H
    MOV RDI, 0H
    syscall
%endmacro

%macro print 2        ;standard write
    MOV RSI, %1
    MOV RDX, %2
    MOV RAX, 1H
    MOV RDI, 1H
    syscall
%endmacro

%macro println 2        ;standard write
    MOV RSI, %1
    MOV RDX, %2
    MOV RAX, 1H
    MOV RDI, 1H
    syscall

    MOV RSI, crlf
    MOV RDX, 1H
    MOV RAX, 1H
    MOV RDI, 1H
    syscall
%endmacro

%macro hex_ascii_adjust 0        ;hex ascii adjust
    MOV BL, AL
    AND BL, 0FH

    CMP BL, 09H
    JLE not_alphabet
        ADD BL, 07H
    not_alphabet :
    
    ADD BL,        30H
    MOV byte[RDI], BL
    INC RDI
%endmacro

%macro trim 1         ; string trim
    MOV RBX, %1

    discard_zeros:
        CMP byte[RBX], '0'
            JNZ break_out_of_loop

        INC RBX

    DEC RCX
    JNZ discard_zeros

    break_out_of_loop:
    ADD RCX, 1H
%endmacro

%macro exit 0
    MOV RAX, 3CH
    MOV RDI, 00H
    syscall
%endmacro


section .data
    crlf              db  '',10                                                                   ;10 is the ASCII for new line
    qword_digit_count dq  10H
    dash_break        db  "---------------------------------------------------------------------"
    dash_break_len    equ $-dash_break

section .bss
    global _start