%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    msg0:
        db  0x0A
        db  "Array Data : "
    msg0_len equ $-msg0

    msg1:
        db  0x0A
        db  "Positive number count : "
    msg1_len equ $-msg1

    msg2:
        db  0x0A
        db  "Negative number count : "
    msg2_len equ $-msg2

    numarr:
        dq 2H
        dq -9H
        dq 5H
        dq 0H
        dq -6H

    cnt:
        db 05H
    pos_cnt:
        dq 05H
    neg_cnt:
        dq 00H


;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    buffer:
        resb 10H

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    MOV  RBP, numarr
    CALL get_count

    print   msg1, msg1_len
    MOV     RAX,  [pos_cnt]
    CALL    display_int

    print   msg2, msg2_len
    MOV     RAX,  [neg_cnt]
    CALL    display_int

    print   msg0, msg0_len

    MOV RBP, numarr
    print_arr:
        print   crlf,   1
        MOV     RAX,    [RBP]                 ; load current number in RAX
        CALL    display_int
        ADD     RBP,    08H
        DEC     byte[cnt]
    JNZ print_arr

exit

;------------------------------------------------DEFN SECTION-----------------------------------------------------------------

get_count:
    MOV CL, 5H

    compare_all_numbers:
        CMP qword[RBP], 0H
        JG  continue            ; jmp if no. is positive
        DEC qword[pos_cnt]

        CMP qword[RBP], 0H
        JE  continue            ; jmp if no. is 0

        INC qword[neg_cnt]

    continue:
        ADD RBP, 08H
        LOOP compare_all_numbers
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