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
    print charOccurMsg,charOccurMsgLen
        inc byte[chacount]
    continue_up_occ:
        inc     rsi
        loop    up3

ret