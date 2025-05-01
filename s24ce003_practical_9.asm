%include 'macros.asm'

section .data
    fname db 'text.txt',0

    openedSuccessfullyMsg db "File opened successfully"
    openedSuccessfullyMsgLen equ $-openedSuccessfullyMsg

    closedSuccessfullyMsg db "File closed successfully"
    closedSuccessfullyMsgLen equ $-closedSuccessfullyMsg

    errorMsg db "Error in opening file"
    errorMsgLen equ $-errorMsg

    spaceMsg db "Spaces:"
    spaceMsgLen equ $-spaceMsg

    nlMsg db "NewLines:"
    nlMsgLen equ $-nlMsg

    charInMsg db "Enter character"
    charInMsgLen equ $-charInMsg

    charOccurMsg db "No of occurrences:"
    charOccurMsgLen equ $-charOccurMsg

    scount dq 0
    ncount dq 0
    ccount dq 0
    chacount dq 0

section .bss
    global buf_len,buffer,scount,ncount,ccount,chacount,charOccurMsg,charOccurMsgLen

    fd      resb 17
    buffer  resb 200
    buf_len resb 16

    cha     resb 2


section .text
    extern occ

_start:


    mov rax,2
    mov rdi,fname
    mov rsi,2
    mov rdx,0777
    syscall

    mov qword[fd],rax

    BT rax,63
    jnc opened_successfully

    CALL display_quad
    print errorMsg,errorMsgLen
    exit

opened_successfully:

    print openedSuccessfullyMsg,openedSuccessfullyMsgLen

    mov rax,0
    mov rdi,[fd]
    mov rsi,buffer
    mov rdx,200
    syscall

    CALL display_quad
    mov qword[buf_len],rax

    ;print spaceMsg,spaceMsgLen

    ;call spaces

    ;print nlMsg,nlMsgLen

    ;call enters

    print charInMsg,charInMsgLen
    read cha,2

    mov bl, byte[cha]

    call occ

    print charOccurMsg,charOccurMsgLen
    MOV RAX,ncount
    CALL display_quad
    
exit

display_quad:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 10H                              ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print   buffer, 10H                         ; print result
RET
