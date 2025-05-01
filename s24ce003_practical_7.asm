%include 'macros.asm'

section .data
    rmode db "IN REAL MODE"
    rmodelen equ $-rmode
    pmode db "IN PROTECTED MODE"
    pmodelen equ $-pmode
    gcon db "GDT : "
    gconlen equ $-gcon
    lcon db "LDT : "
    lconlen equ $-lcon
    icon db "IDT : "
    iconlen equ $-icon
    tcon db "TR : "
    tconlen equ $-tcon
    cro db "CR0 : "
    crolen equ $-cro
    col db ":"
    collen equ $-col

section .bss
    gdt resw 3
    ldt resw 1
    idt resw 3
    tr resw 1
    cr resw 2
    buffer resb 4

section .text

_start:
    smsw [cr]
    mov rax,[cr]

    bt rax,1
    jc proc_mode    

    print rmode,rmodelen
exit

proc_mode:

;-------------MODE---------------
    print pmode,pmodelen

;-------------CR0----------------
    print cro,crolen
    mov rax,[cr+2]
    CALL display_int

    mov rax,[cr]
    CALL display_int
    print 10,1

;-----------LOAD ALL-------------
    sgdt [gdt]
    sldt [ldt]
    sidt [idt]
    str [tr]

;-------------GDT----------------
    print gcon,gconlen
    mov rax, [gdt+4]
    CALL display_int
    mov rax, [gdt+2]
    CALL display_int
    print col,collen
    mov rax, [gdt]
    CALL display_int
    print 10,1

;-------------LDT----------------
    print lcon,lconlen
    mov rax, [ldt]
    CALL display_int
    print 10,1

;-------------IDT----------------
    print icon,iconlen
    mov rax, [idt+4]
    CALL display_int
    mov rax, [idt+2]
    CALL display_int
    mov rax, [idt]
    CALL display_int
    print 10,1

;-----------_--TR--------_--------
    print tcon,tconlen
    mov rax, [tr]
    CALL display_int
    print 10,1
exit

display_int:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 4                                ; how many times should we loop?

    over_all_digits:
        ROL RAX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print buffer, 4                           ; trim the leading '0's from buffer, and print result
RET