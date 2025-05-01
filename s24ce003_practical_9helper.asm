%include 'macros.asm'

section .data
    extern charOccurMsg,charOccurMsgLen,scount,ncount,chacount

section .bss
    pbuffer resb 10H
    extern buf_len,buffer

section .text
    global occ

occ:
    print charOccurMsg,charOccurMsgLen
    mov rsi,buffer
    mov RCX,qword[buf_len]
    up3:
        mov al, byte[rsi]
        cmp al, bl
        jne continue_up_occ
        inc byte[chacount]
    continue_up_occ:
        inc     rsi
        loop    up3

    print charOccurMsg,charOccurMsgLen
    MOV RAX,ncount
    CALL display_int
ret

display_int:
    MOV RDI, pbuffer                            ; destination for the ASCII values
    MOV RCX, 2                                  ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                             ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                       ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print pbuffer, 2                         ; trim the leading '0's from buffer, and print result
RET