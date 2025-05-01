%include 'macros.asm'

;------------------------------------------------DATA SECTION-----------------------------------------------------------------

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
        db "TR  : "
    tconlen equ $-tcon
    
    col:
        db ":"
    collen equ $-col

;------------------------------------------------ BSS SECTION-----------------------------------------------------------------

section .bss
    gdtlimit:
        resw 1
    gdt:
        resq 1     ; resd for a 32 bit pc
    idtlimit:
        resw 1
    idt:
        resq 1     ; resd for a 32 bit pc
    ldt:
        resw 1
    tr:
        resw 1
    cr:
        resd 1
    buffer:
        resd 1

;------------------------------------------------TEXT SECTION-----------------------------------------------------------------

section .text

_start:
    SMSW    [cr]
    MOV     AX,     [cr]
    BT      AX,     1
    JC      proc_mode
    print   rmode,  rmodelen
    exit

proc_mode:

;-------------MODE---------------
    print   pmode,  pmodelen

;-------------CR0----------------
    MOV     AX,     [cr+2]
    CALL    display_word
    MOV     AX,     [cr]
    CALL    display_word

;-----------LOAD ALL-------------
    SGDT    [gdt]
    SLDT    [ldt]
    SIDT    [idt]
    STR     [tr]

;-------------GDT----------------
    print   gcon,   gconlen
    MOV     AX,     [gdt+2]
    CALL    display_word
    MOV     AX,     [gdt]
    CALL    display_word
    print   col,    collen
    MOV     AX,     [gdtlimit]
    CALL    display_word

;-------------IDT----------------
    print   icon,   iconlen
    MOV     AX,     [idt+4]
    CALL    display_word
    MOV     AX,     [idt+2]
    CALL    display_word
    print   col,    collen
    MOV     AX,     [idt]
    CALL    display_word

;-------------LDT----------------
    print   lcon,   lconlen
    MOV     AX,     [ldt]
    CALL    display_word

;--------------TR-----------------
    print   tcon,   tconlen
    MOV     AX,     [tr]
    CALL    display_word
exit

;------------------------------------------------DEFN SECTION-----------------------------------------------------------------

display_word:
    MOV RDI, buffer                           ; destination for the ASCII values
    MOV RCX, 4                                ; how many times should we loop?(digit count)

    over_all_digits:
        ROL AX, 4H                           ; rotate the number by 4 bits so that the 'next MSB' is loaded into AL
        hex_ascii_adjust                      ; macro for hex ascii adjust of AL
    LOOP over_all_digits

    print buffer, 4                           ; print result
RET

; IN PROTECTED MODE
; CR0 : 00000033            // Valid Output for CR0 and TR
; GDT : FFFE0000:0000       // OS doesnt allow us to access the
; IDT : FFFF0000:0000       // GDT, IDT and (unsure)LDT, and
; LDT : 0000                // instead gives fake values
; TR  : 0040                //                  ~ ChatGPT