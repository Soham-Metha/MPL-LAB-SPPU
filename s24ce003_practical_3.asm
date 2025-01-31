%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    msg1     db  "Largest Number : "
    msg1_len equ $-msg1
    msg2     db  "Array Data : "
    msg2_len equ $-msg2

    numarr dq 2H,9H,5H,3H,6H                  ; actual content of array
    cnt    dq 05H                             ; count of numbers in array

    qword_byte_count dq 08H                   ; bytes assigned to each number

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    buffer resb 10H                           ; reserve buffer for the ASCII adjust

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    MOV     RBP,  numarr
    CALL    find_largest

    printbr msg1, msg1_len
    MOV     RAX,  RBX                         ; load largest number in RAX
    CALL    display_int
    
    MOV     RBP,  numarr                      ; reset rbp

    printbr 
    println msg2, msg2_len

    print_arr:
        MOV  RAX, [RBP]                       ; load current number in RAX
        CALL display_int
        ADD  RBP, [qword_byte_count]
        DEC  byte[cnt]
    JNZ print_arr
exit

;------------------------------------------------DEFN SECTION-----------------------------------------------------------------

find_largest:
    MOV RBX, [RBP]
    MOV RCX, [cnt]

    compare_all_digits:
        CMP RBX, [RBP]
        JGE continue_to_next_iteration
        MOV RBX, [RBP]

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