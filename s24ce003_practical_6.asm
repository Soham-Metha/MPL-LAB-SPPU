%INClude 'macros.asm'

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

    invalid_msg: 
        db "Invalid input!", 0xA
    invalid_msg_len equ $-invalid_msg

    Out_msg:
        db "Result: "
    out_msg_len: equ $-Out_msg

section .bss

    choice:
        resb 3
    input:
        resb 6
    buffer:
        resb 8
    inputLen:
        resb 4

section .text

menustart:
    print   buffer, 8                               ; print result
_start:
    print   menu_msg,       menu_msg_len
    read    choice,         2

    print   In_msg,         in_msg_len
    read    input,          6
    DEC     EAX
    MOV     [inputLen],     EAX
    MOV     RAX,            0

    PUSH    menustart                                  ; RET RETurns to the ADDress at top of stack
    MOV     ESI,    input

    cmp     byte[choice],   '1'
    jz      h2bHanDLer

    cmp     byte[choice],   '2'
    jz      b2hHanDLer
exit

h2bHanDLer:
    CMP     dword[inputLen],     4
    JNE     invalid

    CALL    ascii_hex_to_hex
    MOV     EDI,    buffer+7                            ; destination for the ASCII values
    CALL    hex_to_bcd
    RET

b2hHanDLer:
    CMP     dword[inputLen],     5
    JNE     invalid

    CALL    bcd_to_hex
    MOV     EDI,    buffer+7                            ; destination for the ASCII values
    CALL    hex_to_ascii_hex
    RET

invalid:
    print   invalid_msg, invalid_msg_len
    exit

ascii_hex_to_hex:
    MOV     RCX,    [inputLen]                                   ; how many times should we loop?(digit count)

    over_all_digits2:
        ROL AX,     4                                   ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        MOV BL,     [ESI]

        CMP BL,     '9'
        JBE not_alphabet2
        SUB BL,     07H

    not_alphabet2:
        SUB BL,     '0'
        OR  AL,     BL
        INC ESI
    LOOP over_all_digits2

RET

hex_to_ascii_hex:
    MOV     RCX,    4                                   ; how many times should we loop?(digit count)

    over_all_digits:
        MOV BL,     AL
        AND BL,     0FH
        CMP BL,     09H
        JBE not_alphabet
        ADD BL,     07H

    not_alphabet:
        ADD BL,     '0'
        MOV [EDI],  BL
        ROL AX,     4                             ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        DEC EDI
    LOOP over_all_digits
RET

hex_to_bcd:
    MOV     EBX,    10
    MOV     ECX,    [inputLen]
.bcd_loop:
    XOR     EDX,    EDX
    DIV     EBX
    ADD     DL,     '0'
    MOV     [EDI],  DL
    DEC     EDI
    LOOP    .bcd_loop
    RET

bcd_to_hex:
    MOV     EBX,    10
    MOV     ECX,    [inputLen]
.num_loop:
    IMUL    EBX
    MOV     DL,     [ESI]
    SUB     DL,     '0'
    ADD     EAX,    EDX
    INC     ESI
    LOOP    .num_loop
    RET