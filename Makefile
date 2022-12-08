
TARGET := clever-elf

BFD_NAME := elf64-clever

AS := $(TARGET)-as
LD := $(TARGET)-ld 
OBJCOPY := $(TARGET)-objcopy
STRIP := $(TARGET)-strip



BIOS_DRIVERS := 

USE_EFI := no

EFI_DRIVERS := fat32 pe 

MS_OBJS := $(patsubst %.s,%.o,$(wildcard machine-specific/*.s))

BIOS_OBJS := main.o $(foreach bios_driver,$(BIOS_DRIVERS),$(bios_driver).o)

EFI_OBJS := efi/main.o efi/boot-services.o efi/run-services.o $(foreach efi_driver,$(EFI_DRIVERS),efi/$(efi_driver).o)

BIOS_ONLY_OBJS := bios-boot.o

OBJS := $(BIOS_OBJS) $(MS_OBJS)

ifeq ($(USE_EFI),yes)
   OBJS += $(EFI_OBJS)
else
	OBJS += $(BIOS_ONLY_OBJS)
endif

OUTPUT := bios

all: stamp

stamp: $(OUTPUT)
	touch stamp

$(OUTPUT): $(OUTPUT).elf $(OUTPUT).dbg
	$(OBJCOPY) -I $(BFD_NAME) -O binary --remove-section .bss --strip-debug $(OUTPUT).elf $(OUTPUT)

$(OUTPUT).dbg: $(OUTPUT).elf
	$(OBJCOPY) --only-keep-debug $(OUTPUT).elf $(OUTPUT).dbg

$(OUTPUT).elf: $(OBJS) linker.ld
	$(LD) -T linker.ld -o $(OUTPUT).elf $(OBJS)

%.o: %.s
	$(AS) -o $@ $^

clean:
	rm -f stamp $(OBJS) $(MS_OBJS) $(EFI_OBJS) $(BIOS_ONLY_OBJS) $(OUTPUT) $(OUTPUT).elf $(OUTPUT).dbg

.PHONY: all clean

.DEFAULT_GOAL: all