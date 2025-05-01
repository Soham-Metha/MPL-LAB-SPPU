%include 'macros.asm'

section .data
    fname db 'text.txt',0

    openedSuccessfullyMsg db "File opened successfully"
    openedSuccessfullyMsgLen equ $-openedSuccessfullyMsg

    closedSuccessfullyMsg db "File closed successfully"
    closedSuccessfullyMsgLen equ $-closedSuccessfullyMsg

    errorMsg db "Error in opening file"
    errorMsgLen equ $-errorMsg

    charInMsg db "Enter character"
    charInMsgLen equ $-charInMsg

section .bss
    global buf_len,buffer,cha

    fd      resb 17
    buffer  resb 200
    buf_len resb 16

    cha     resb 2


section .text
    extern spaces,enters,char

_start:

    mov rax,2
    mov rdi,fname
    mov rsi,2
    mov rdx,0777
    syscall

    mov qword[fd],rax

    BT rax,63
    jnc opened_successfully

    print errorMsg,errorMsgLen
    exit

opened_successfully:

    print openedSuccessfullyMsg,openedSuccessfullyMsgLen

    mov rax,0
    mov rdi,[fd]
    mov rsi,buffer
    mov rdx,200
    syscall

    mov qword[buf_len],rax

    print charInMsg,charInMsgLen
    read cha,2

    call spaces
    call enters
    call char

exit
