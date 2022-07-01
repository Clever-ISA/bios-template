.section .rodata.interrupt
itable: // addr 0x0000
.quad 64, 0,
.quad 0, 0
.quad abort, 0x18000
.quad 0, 0
.quad undefined, 0x18000
.quad 0, 0
.space 448

.section .text

.global _start

abort:
    mov r2, 0x100000000
    mov r1, 24
    lea r4, [short ._S0+ip]
    repbc out byte
    abort._L0:
    hlt
    jmp abort._L0
    abort._S0:
    .byte "Abort Interrupt Recieved\n"

.align 2

undefined:
    mov r2, 0x100000000
    mov r1, 22
    lea r4, [short ._S1+ip]
    repbc out byte
    hlt
    jmp abort._L0
    undefined._S1:
    .byte "Undefined Instruction\n"




.section .text.init
_start:
    mov r7, short stack+ip
    mov cr6, short itable
    mov r2, 0x7f000000
    in double
    and r0, short 0x13
    lea r0 , [__machine_init+ip]
    cmp r0, 0
    jeq _start._L0
    call rel __machine_init
    _start._L0:
    jmp begin_boot
    
    jmp _start._L0

.section .bss
.space 8192
stack:

