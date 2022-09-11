
TARGET := clever1.0-elf

BFD_NAME := elf64-clever

AS := $(TARGET)-as
LD := $(TARGET)-ld 
OBJCOPY := $(TARGET)-objcopy
STRIP := $(TARGET)-strip



BIOS_DRIVERS := pci ahci acpi spi usb

USE_EFI := no

EFI_DRIVERS := fat32 pe 

MS_OBJS := $(patsubst %.s,%.o,$(wildcard machine-specific/*.s))

BIOS_OBJS := main.o $(foreach bios_driver,$(BIOS_DRIVERS),$(BIOS_DRIVER).o)

EFI_OBJS := efi/main.o efi/boot-services.o efi/run-services.o $(foreach efi_driver,$(EFI_DRIVERS),efi/$(EFI_DRIVERS).o)

BIOS_ONLY_OBJS := bios-boot.o

OBJS := $(BIOS_OBJS) $(MS_OBJS)

ifeq ($(USE_EFI),yes)
   OBJS += $(EFI_OBJS)
else
	OBJS += $(BIOS_ONLY_OBJS)
endif

OUTPUT := bios

$(OUTPUT): $(OUTPUT).elf $(OUTPUT).dbg
	$(OBJCOPY) -I $(BFD_NAME) -O binary --remove-section .bss $(OUTPUT).elf $(OUTPUT)

$(OUTPUT).dbg: $(OUTPUT).elf
	$(OBJCOPY) --only-keep-debug $(OUTPUT).elf $(OUTPUT).dbg
	$(STRIP) $(OUTPUT).elf

$(OUTPUT).elf: $(OBJS)
	$(LD) -T linker.ld -o $(OUTPUT).elf $(OBJS)

%.o: %.s
	$(AS) -o $@ $^

