ENTRY(_start)
SECTIONS {
    .rodata.interrupt: 0 {
        __BEGIN_RODATA = .;
        main.o(.rodata.interrupt);
    };

    .rodata: ALIGN(16) {
        *(.rodata);
        __END_RODATA = .;
    };

    .text: ALIGN(16){
        __BEGIN_TEXT = .;
        *(.text);
        __END_TEXT = .;
    };


    .text.init: 0xff00{
        __BEGIN_TEXT_INIT = .;
        main.o(.text.init);
        machine-specific/*.o(.text.init);
        __END_TEXT_INIT = .;
    };

    .bss: 0x10000{
        __BEGIN_BSS = .;
        *(.bss);
        __END_BSS = .;
    };
}