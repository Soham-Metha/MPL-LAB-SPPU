%include 'macros.asm'

section .data
    rmode:
        db 0x0A
        db "IN REAL MODE"
    rmodelen equ $-rmode

    pmode:
        db 0x0A
        db "IN PROTECTED MODE"
        db 0x0A
        db "CR0 : "
    pmodelen equ $-pmode

    gcon:
        db 0x0A
        db "GDT : "
    gconlen equ $-gcon
    
    lcon:
        db 0x0A
        db "LDT : "
    lconlen equ $-lcon
    
    icon:
        db 0x0A
        db "IDT : "
    iconlen equ $-icon
    
    tcon:
        db 0x0A
        db "TR : "
    tconlen equ $-tcon
    
    col:
        db ":"
    collen equ $-col

section .bss
    gdt:
        resb 6
    ldt:
        resb 2
    idt:
        resb 6
    tr:
        resb 2
    cr:
        resb 10
    buffer:
        resb 4

section .text

_start:
    smsw [cr]
    mov AX,[cr]

    bt AX,1
    jc proc_mode

    print rmode,rmodelen
exit

proc_mode:

;-------------MODE---------------
    print pmode,pmodelen

;-------------CR0----------------
    mov AX,[cr+2]
    CALL display_int

    mov AX,[cr]
    CALL display_int

;-----------LOAD ALL-------------
    sgdt [gdt]
    sldt [ldt]
    sidt [idt]
    str [tr]

;-------------GDT----------------
    print gcon,gconlen
    mov AX, [gdt+4]
    CALL display_int
    mov AX, [gdt+2]
    CALL display_int
    print col,collen
    mov AX, [gdt]
    CALL display_int

;-------------LDT----------------
    print lcon,lconlen
    mov AX, [ldt]
    CALL display_int

;-------------IDT----------------
    print icon,iconlen
    mov AX, [idt+4]
    CALL display_int
    mov AX, [idt+2]
    CALL display_int
    mov AX, [idt]
    CALL display_int

;--------------TR-----------------
    print tcon,tconlen
    mov AX, [tr]
    CALL display_int
exit

display_int:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 4                                ; how many times should we loop?(digit count)

    over_all_digits:
        ROL AX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print buffer, 4                           ; print result
RET