%include 'macros.asm'

section .data
    fname db 'text.txt',0

    openedMsg:
        db "File opened successfully",0x0A
        db "Enter character : "
    openedMsgLen equ $-openedMsg

    errorMsg db "Error in opening file"
    errorMsgLen equ $-errorMsg

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

    print openedMsg,openedMsgLen
    read cha,2

    mov rax,0
    mov rdi,[fd]
    mov rsi,buffer
    mov rdx,200
    syscall

    mov qword[buf_len],rax
    print buffer,buf_len
    call spaces
    call enters
    call char

exit
