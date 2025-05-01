%include 'macros.asm'

section .data
    extern charOccurMsg,charOccurMsgLen,scount,ncount,chacount

section .bss
    pbuffer resb 10H
    extern buf_len,buffer

section .text
    global occr

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

ret