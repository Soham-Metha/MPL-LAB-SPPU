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

%macro println 2
    print %1, %2
    print crlf, 1H
%endmacro

%macro printbr 0-2
    println dash_break, dash_break_len

    %if %0 == 2
        print %1, %2
    %endif

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

%macro printtr 2
    MOV RBX, %1
    MOV RCX, %2
    DEC RCX
    
    discard_zeros:
        CMP byte[RBX], '0'
        JNZ break_out_of_loop
        INC RBX
    LOOP discard_zeros

    break_out_of_loop:
        ADD RCX, 1H
        println RBX, RCX
%endmacro

%macro exit 0
    printbr
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