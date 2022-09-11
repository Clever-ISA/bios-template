.section .rodata.interrupt
itable: // addr 0x0000
.quad 64, 0
.quad 0, 0
.quad abort, 0x18000
.quad 0, 0
.quad undefined, 0x18000
.quad 0, 0
.space 448

.section .text

.global _start

.weak __machine_init

abort:
undefined:
    abort._L0:
    hlt
    jmp abort._L0

.align 2




.section .text.init
_start:
    mov r7, half stack+ip
    mov cr6, short itable
    lea r0, [__machine_init]
    cmp r0, 0
    jeq _start._L0
    call rel __machine_init
    _start._L0:
    jmp begin_boot

.section .bss
.space 8192
stack:

