
.global begin_boot

.weak __machine_serial_read __machine_serial_write

.rodata
boot_error:
.ascii "No bootable Device Found. Resetting"

.text

begin_boot:
    mov r12, half abs __begin_enumerate_drives
    mov r13, half abs __end_enumerate_drives
    lea r1, [__block_array+ip]
    begin_boot._L0:
    cmp r12, r13
    jeq begin_boot._L1
    mov r0, double [r12]
    icall r0
    mov r1, r0
    lea r12, [r12+8]
    jmp begin_boot._L0
    begin_boot._L1:
    mov r13, r0
    lea r12, [__block_array+ip]
    begin_boot._L2:
    mov r0, [r12]
    mov r2, [r12+8]
    test r2, 0xffff000000000000
    je begin_boot._L3
    mov r1, single 0x1000000
    mov r3, 0x200
    icall r0
    mov r12, [r12+8]
    mov r0, half [0x100001FE]
    test r0, short 0x55AA
    je 0x1000000
    lea r12, [r12+16]
    jmp begin_boot._L2
    begin_boot._L3:
    lea r0, __machine_serial_write
    test r0, r0
    je begin_boot._L4
    lea r5, [boot_error]
    mov r4, 32
    call __machine_serial_write
    lea r0, __machine_serial_read
    test r0, r0
    je begin_boot._L4
    lea r5, [r7]
    mov r4, 1
    call __machine_serial_read
    begin_boot._L4:
    mov double [half 0], short 0
    und // No software reset yet, so nuke the itab and execute an illegal instruction to reset the processor


.bss
// Array Elements:
// void (*read)(uint64_t, void*, size_t);
// uint64_t id;
__block_array:
.space 4096
