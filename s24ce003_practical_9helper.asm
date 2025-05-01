%include 'macros.asm'

section .data
    extern charOccurMsg,charOccurMsgLen,chacount

section .bss
    pbuffer resb 10H
    extern buf_len,buffer

section .text
    global char,spaces,enters

spaces:
    mov bl,' '
    CALL occr
    
enters:
    mov bl,0x0A
    CALL occr

char:
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