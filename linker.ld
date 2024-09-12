ENTRY(_start)

PHDRS {
    text PT_LOAD;
    data PT_LOAD;
}

SECTIONS {
    .rodata.interrupt 0:  {
        __BEGIN_RODATA = .;
        main.o(.rodata.interrupt);
    } :text

    .rodata.enumerate ALIGN(16) :{
        __begin_enumerate_drives = .;
        KEEP(*(.rodata.enumerate));
        __end_enumerate_drives = .;
    }

    .rodata  ALIGN(16): {
        *(.rodata);
        __END_RODATA = .;
    }

    .text ALIGN(1024): {
        __BEGIN_TEXT = .;
        *(.text);
        __END_TEXT = .;
    }


    .text.init 0xff00: {
        __BEGIN_TEXT_INIT = .;
        KEEP(main.o(.text.init));
        __END_TEXT_INIT = .;
        . = ABSOLUTE(0xFFFF);
        BYTE(0);
    }

    .bss 0x10000:{
        __BEGIN_BSS = .;
        *(.bss);
        *(COMMON);
        __END_BSS = .;
    } :data
}