%include 'macros.asm'

section .data
    srcblk:
        db 01h
        db 02h
        db 03h
        db 04h
        db 05h
    dstblk:
        db 00h
        db 00h
        db 00h
        db 00h
        db 00h
    menu_msg:
        db  0x0A,0x0A
        db  "-------------------",0x0A
        db "1. W/O STR OPR      ",0x0A
        db "2. W STR OPR        ",0x0A
        db "3. EXIT             ",0x0A
        db  "-------------------",0x0A
        db "Your Choice : "
    menu_msg_len: equ $-menu_msg

    src_msg:
        db  0x0A
        db "SRC : "
    src_msg_len: equ $-src_msg

    dst_msg:
        db  0x0A
        db "DST : "
    dst_msg_len: equ $-dst_msg

    cnt:
        db 5
    space:
        db ' '

section .bss
    choice:
        resb 2
    buffer:
        resb 1

section .text

_start:

    print   src_msg,        src_msg_len
    MOV     RBP,            srcblk
    CALL    printarray

    print   dst_msg,        dst_msg_len
    MOV     RBP,            dstblk
    CALL    printarray

    print   menu_msg,       menu_msg_len
    read    choice,         2

    PUSH    end

    cmp     byte[choice],   '1'
    jz      wostr

    cmp     byte[choice],   '2'
    jz      wstr

end:
    print   dst_msg,        dst_msg_len
    MOV     RBP,            dstblk
    CALL    printarray
exit

wostr:
    mov rsi,    srcblk
    mov rdi,    dstblk
    mov rcx,    5
    
    again:
    mov bl,     [rsi]
    mov [rdi],  bl
    inc rsi
    inc rdi
    loop again
ret

wstr:
    mov rsi, srcblk
    mov rdi, dstblk
    mov rcx, 5

    cld
    rep movsb
ret

printarray:
    MOV         byte[cnt],  5
    print_arr:
        print   space,      1
        MOV     RAX,        [RBP]                 ; load current number in RAX
        CALL    display_byte
        ADD     RBP,        01H
        DEC     byte[cnt]
    JNZ print_arr
RET

display_byte:
    MOV     RDI,    buffer                      ; destination for the ASCII values
    hex_ascii_adjust                            ; macro for hex ascii adjust of AL
    print   buffer, 1                           ; print result
RET