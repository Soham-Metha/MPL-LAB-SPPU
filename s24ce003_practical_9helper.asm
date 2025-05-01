%include 'macros.asm'

section .data
    extern charOccurMsg,charOccurMsgLen

    spaceMsg:
        db 0x0A
        db "Spaces:"
    spaceMsgLen equ $-spaceMsg

    nlMsg:
        db 0x0A
        db "NewLines:"
    nlMsgLen equ $-nlMsg

    charOccurMsg:
        db 0x0A
        db "No of occurrences:"
    charOccurMsgLen equ $-charOccurMsg

    count: dw 0

section .bss
    pbuffer resb 10H
    extern buf_len,buffer,cha

section .text
    global char,spaces,enters

spaces:
    print spaceMsg,spaceMsgLen
    mov bl,' '
    CALL occr
    MOV  byte[count],0
RET
enters:
    print nlMsg,nlMsgLen
    mov bl,0x0A
    CALL occr
    MOV  byte[count],0
RET

char:
    print charOccurMsg,charOccurMsgLen
    mov bl,byte[cha]
    CALL occr
    MOV  byte[count],0
RET

occr:
    mov rsi,buffer
    mov RCX,qword[buf_len]
    up:
        mov al, byte[rsi]
        cmp al, bl
        jne continue
        inc byte[count]
    continue:
        inc     rsi
        loop    up

    MOV RAX,[count]
    CALL display_word
ret

display_word:
    MOV RDI, pbuffer                           ; destination for the ASCII values
    MOV RCX, 08H                              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print pbuffer, 08H                         ; print result
RET
