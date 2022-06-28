
.global begin_boot

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
    


.bss
// Array Elements:
// void (*read)(void*, size_t);
// uint64_t id;
__block_array:
.space 4096