
.global init_pci

.weak __machine_init_pci

init_pci:
    mov r0, 1
    xchg quad [pci_init], r0
    test r0, r0
    jne init_pic._L2
    lea r0, [__machine_init_pci]
    test r0, r0
    jne init_pci._L0
    call __machine_init_pci
    init_pci._L0:
    mov r0, 0x7f00000f
    in quad
    add r1, 0x40000
    cmp r1, 0x90000000
    ja init_pci._L1
    mov r1, 0x9000000 // move the VGA Buffer passed the PCI Configuration Space
    out quad
    mov r0, 0x7f00000e
    init_pci._L1;
    mov r1, 0x80000000
    out quad
    init_pci._L2:
    ret


.bss
pci_init:
.space 8