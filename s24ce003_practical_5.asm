%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    msg0     db  "Array Data : "
    msg0_len equ $-msg0
    msg1     db  "Positive number count : "
    msg1_len equ $-msg1
    msg2     db  "Negative number count : "
    msg2_len equ $-msg2

    numarr  dq 2H,-9H,5H,0H,-6H
    cnt     dq 05H
    pos_cnt dq 05H
    neg_cnt dq 00H

    qword_byte_count dq 08H

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    buffer resb 10H

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    MOV  RBP, numarr
    CALL get_count

    printbr msg1, msg1_len
    MOV     RAX,  [pos_cnt]
    CALL    display_int

    printbr msg2, msg2_len
    MOV     RAX,  [neg_cnt]
    CALL    display_int

    printbr
    println msg0, msg0_len

    MOV RBP, numarr
    print_arr:
        MOV  RAX, [RBP]
        CALL display_int
        ADD  RBP, [qword_byte_count]
        DEC  byte[cnt]
    JNZ print_arr

exit

;------------------------------------------------DEFN SECTION-----------------------------------------------------------------

get_count:
    MOV RCX, [cnt]

    compare_all_digits:
        CMP qword[RBP], 0H
        JG  continue_to_next_iteration
        DEC qword[pos_cnt]

        CMP qword[RBP], 0H
        JE  continue_to_next_iteration

        INC qword[neg_cnt]

    continue_to_next_iteration:
        ADD RBP, [qword_byte_count]
    LOOP compare_all_digits
RET

display_int:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, [qword_digit_count]              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    printtr buffer, [qword_digit_count]       ; trim the leading '0's from buffer, and print result
RET