%macro read 2
    MOV RSI, %1
    MOV RDX, %2
    MOV RAX, 0H
    MOV RDI, 0H
    syscall
%endmacro

%macro print 2
    MOV RSI, %1
    MOV RDX, %2
    MOV RAX, 1H
    MOV RDI, 1H
    syscall
%endmacro

%macro hex_ascii_adjust 0
    MOV BL, AL
    AND BL, 0FH

    CMP BL, 09H
    JLE not_alphabet
    ADD BL, 07H

    not_alphabet:
        ADD BL,        30H
        MOV byte[RDI], BL
        INC RDI
%endmacro

%macro exit 0
    print   crlf,1
    MOV RAX, 3CH
    MOV RDI, 00H
    syscall
%endmacro

section .data
    crlf:
        db  0x0A                                                                   ; ASCII for new line

section .text
    global _start
