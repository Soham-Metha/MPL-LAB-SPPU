%include 'macros.asm'

section .data
    extern charOccurMsg,charOccurMsgLen,chacount

    spaceMsg db "Spaces:"
    spaceMsgLen equ $-spaceMsg

    nlMsg db "NewLines:"
    nlMsgLen equ $-nlMsg

    charOccurMsg db "No of occurrences:"
    charOccurMsgLen equ $-charOccurMsg

section .bss
    pbuffer resb 10H
    extern buf_len,buffer,cha

section .text
    global char,spaces,enters

spaces:
    print spaceMsg,spaceMsgLen
    mov bl,' '
    CALL occr

enters:
    print nlMsg,nlMsgLen
    mov bl,0x0A
    CALL occr

char:
    print charOccurMsg,charOccurMsgLen
    mov bl,byte[cha]
    CALL occr

occr:
    print buffer,buf_len
    mov rsi,buffer
    mov RCX,qword[buf_len]
    up3:
        mov al, byte[rsi]
        cmp al, bl
        jne continue
        inc byte[chacount]
    continue:
        inc     rsi
        loop    up3

    MOV RAX,[chacount]
    CALL display_quad
ret

display_quad:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 10H                              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print   buffer, 10H                         ; print result
RET
