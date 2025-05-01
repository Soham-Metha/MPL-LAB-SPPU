%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    msg1:
        db  "Largest Number : "
    msg1_len equ $-msg1

    msg2:
        db  0x0A
        db  "Array Data : "
    msg2_len equ $-msg2

    numarr:
        dq 2H
        dq 9H
        dq 5H
        dq 3H
        dq 6H                               ; actual content of array

    cnt:
       db 05H                               ; count of numbers in array

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    buffer:
        resb 10H                           ; reserve buffer for the ASCII adjust

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    MOV     RBP,  numarr
    CALL    find_largest

    print   msg1, msg1_len
    MOV     RAX,  RBX                         ; load largest number in RAX
    CALL    display_int
    
    print msg2, msg2_len

    MOV     RBP,  numarr                      ; reset rbp
    print_arr:
        print   crlf,   1
        MOV     RAX,    [RBP]                 ; load current number in RAX
        CALL    display_int
        ADD     RBP,    08H
        DEC     byte[cnt]
    JNZ print_arr

exit

;------------------------------------------------DEFN SECTION-----------------------------------------------------------------

find_largest:
    MOV RBX, [RBP]
    MOV CX,  5H

    compare_all_numbers:
        CMP RBX, [RBP]
        JGE continue
        MOV RBX, [RBP]

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