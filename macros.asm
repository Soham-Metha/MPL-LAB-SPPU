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

section .bss
    buffer:
        resb 10H

section .text
    global _start

display_quad:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 10H                              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print   buffer, 10H                         ; print result
RET

find_largest:
    MOV RBX, [RBP]
    MOV CL,  5H

    compare_all_numbers:
        CMP RBX, [RBP]
        JGE continue
        MOV RBX, [RBP]

    continue:
        ADD RBP, 08H
        LOOP compare_all_numbers
RET
