%include 'macros.asm'

section .data
    message:
        db "Factorial: "
    len: equ $-message

section .bss
    buffer resb 10H

section .text
    global _start

_start:
    print   message, len

    pop     rcx
    cmp     rcx, 2
    jl      end

    pop     rdi        ; Skip program name
    pop     rdi        ; Get argv[1] (number)

    xor     rbx,     rbx

convert_loop:
    xor     rax,    rax
    mov     al,     byte [rdi]
    cmp     al,     0
    jz      convert_done

    sub     al,     '0'
    imul    rbx,     10
    add     rbx,     rax                 ; rbx = rbx*10 + RAX

    inc     rdi
    jmp     convert_loop

convert_done:
    mov     rax,     1
    cmp     rbx,     1
    jle     factorial_end

factorial_loop:
    imul    rbx
    dec     rbx
    cmp     rbx,     1
    jg      factorial_loop

factorial_end:

    mov     edi,    buffer+0FH
    call    hex_to_bcd
    print   buffer, 10H

end:
    exit

hex_to_bcd:
    MOV     EBX,    10
    MOV     ECX,    0FH
.bcd_loop:
    XOR     EDX,    EDX
    DIV     EBX
    ADD     DL,     '0'
    MOV     [EDI],  DL
    DEC     EDI
    LOOP    .bcd_loop
RET
