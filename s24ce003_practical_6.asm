%include 'macros.asm'

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

    invalid_msg db "Invalid input!", 0xA
    Out_msg:
        db "Result: "
    out_msg_len: equ $-Out_msg

section .bss

    choice:
        resb 3
    input:
        resb 6
    output:
        resb 6
    buffer:
        resb 8

section .text

menustart:
_start:
    print menu_msg,menu_msg_len
    read choice, 2

    CMP byte[choice], '3'                           ; user has only 2 options, 1 & 2
    JGE end                                         ; if user enters some other option, exit

    CMP byte[choice], '0'                           ; 0 is not a valid choice
    JE  end

    print In_msg, in_msg_len
    read input, 6

    PUSH menustart                                  ; ret returns to the address at top of stack

    cmp byte[choice], '1'
    jz  h2bHandler

    cmp byte[choice], '2'
    jz  b2hHandler
end:
    exit

h2bHandler:
b2hHandler:
    MOV EBX,dword[input]
    CALL get_bin_word
    CALL display_quad

get_bin_word:
    MOV RAX, 0
    MOV RSI, input
    MOV RCX, 4                                ; how many times should we loop?(digit count)

    over_all_digits2:
        ROL RAX, 4                             ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        MOV BL, [RSI]

        CMP BL, '9'
        JBE not_alphabet2
        SUB BL, 07H

        not_alphabet2:
            SUB BL, '0'
            OR  AL, BL
            INC RSI
    LOOP over_all_digits2

RET

display_quad:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 10H                              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print   buffer, 10H                         ; print result
RET