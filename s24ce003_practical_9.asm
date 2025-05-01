%include 'macros.asm'

section .data
    fname db 'text.txt'

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

    fd      resb 16
    buffer  resb 200
    buf_len resb 16

    cha     resb 2


section .text

_start:

    extern occ

    mov rax,2
    mov rdi,fname
    mov rsi,2
    mov rdx,777
    syscall

    mov qword[fd],rax

    BT rax,63
    jc opened_successfully

    println errorMsg,errorMsgLen
    exit

opened_successfully:

    println openedSuccessfullyMsg,openedSuccessfullyMsgLen

    mov rax,0
    mov rdi,[fd]
    mov rsi,buffer
    mov rdx,200
    syscall

    mov qword[buf_len],rax

    ;println spaceMsg,spaceMsgLen

    ;call spaces

    ;println nlMsg,nlMsgLen

    ;call enters

    println charInMsg,charInMsgLen
    read cha,2

    mov bl, byte[cha]

    call occ

exit