
find_ahci_devs:
    call init_pci
    mov r0, 0x10000
    mov r1, 0x80000000
    find_ahci_devs._L0:
    mov r2, single [r1+8]
    rsh r2, 24
    cmp r2, 1
    jne find_ahci_devs._L1
    

