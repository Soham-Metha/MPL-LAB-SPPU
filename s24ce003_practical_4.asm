%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

section .data

    num1  dq  20H
    num2  dq  10H

    menu_msg:
        db  0x0A,0x0A
        db  "-------------------",0x0A
        db  "1. Addition        ",0x0A
        db  "2. Subtraction     ",0x0A
        db  "3. Multiplication  ",0x0A
        db  "4. Division        ",0x0A
        db  "5. Shift left      ",0x0A
        db  "6. Shift right     ",0x0A
        db  "-------------------",0x0A
        db  "Enter your choice : "

    menu_msg_len: equ $-menu_msg

    result_message:
        db  "Result : "
    result_message_len:  equ $-result_message

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss

    choice resb 01H
    buffer resb 10H

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

menustart:
    CALL    display_quad                             ; prints result stored in AX
_start:

    print   menu_msg, menu_msg_len                  ; print menu
    read    choice,   2                             ; read 2 characters, 1st is user choice and 2nd is the enter key

    CMP byte[choice], '7'                           ; user has only 6 options, 1 to 6
    JGE end                                         ; if user enters some other option, exit

    CMP byte[choice], '0'                           ; 0 is not a valid choice
    JE  end

    print result_message, result_message_len        ; print the "Result : " string

    PUSH menustart                                  ; ret returns to the address at top of stack

    cmp byte[choice], '1'
    jz  addHandler

    cmp byte[choice], '2'
    jz  subHandler

    cmp byte[choice], '3'
    jz  mulHandler

    cmp byte[choice], '4'
    jz  divHandler

    cmp byte[choice], '5'
    jz  shlHandler

    cmp byte[choice], '6'
    jz  shrHandler

end:
    exit

;------------------------------------------------DEFN SECTION-----------------------------------------------------------------

addHandler:
    MOV RAX, [num1]
    ADD RAX, qword[num2]
RET

subHandler:
    MOV RAX, [num1]
    SUB RAX, qword[num2]
RET

mulHandler:
    MOV  RAX, [num1]
    IMUL qword[num2]
RET

divHandler:
    MOV RDX, 0
    MOV RAX, [num1]
    IDIV qword[num2]
RET

shlHandler:
    MOV RAX, [num1]
    SHL RAX, 1
RET

shrHandler:
    MOV RAX, [num1]
    SHR RAX, 1
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
