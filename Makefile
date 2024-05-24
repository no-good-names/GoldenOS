CC = i386-elf-gcc
LD = i386-elf-ld
OBJCOPY = i386-elf-objcopy
QEMU = qemu-system-i386

SRC=$(shell pwd)
## Directory to write binaries to
BIN=./bin
## Compiler Flags
FLAGS=-ffreestanding -m32 -g 

## C source files
CSRC := $(shell find ./ -name "*.c")
## C target files
CTAR := $(patsubst %.c,%.o,$(CSRC))

## Assembly source files that must be compiled to ELF
ASMSRC :=  ./Bootloader/gdt.asm ./Kernel/kernel_entry.asm
## Assembly target files
ASMTAR := $(patsubst %.asm,%.o,$(ASMSRC))

all: prebuild build

debug: prebuild build
	$(OBJCP) --only-keep-debug $(BIN)/kernel.elf $(BIN)/kernel.sym
	gdb -ex "target remote localhost:1234" -ex "symbol-file $(BIN)/kernel.sym"

	qemu-system-x86_64 -drive format=raw,file=osimage_formated.bin,index=0,if=floppy -hda disk.img -m 128M -s -S &

prebuild:	## Prebuild instructions
	rm -rf $(BIN)
	mkdir $(BIN)

build: boot $(ASMTAR) $(CTAR)
	$(LD) -o $(BIN)/kernel.elf -TKernel/kernel.ld $(shell find ./ -name "*.o" | xargs)
	$(OBJCOPY) -O binary $(BIN)/kernel.elf $(BIN)/kernel.bin
	cat $(BIN)/boot.bin $(BIN)/boot_2.bin > $(BIN)/both_boot.bin
	cat $(BIN)/both_boot.bin $(BIN)/kernel.bin > $(BIN)/short.bin
	cat $(BIN)/short.bin $(BIN)/zeros.bin > $(BIN)/os_image.bin
	dd if=/dev/zero of=$(BIN)/osimage_formated.img bs=512 count=2880 >/dev/null
	dd if=$(BIN)/os_image.bin of=$(BIN)/osimage_formated.img conv=notrunc >/dev/null

boot:
	nasm Bootloader/boot.asm -f bin -o $(BIN)/boot.bin -i Bootloader
	nasm Bootloader/boot_2.asm -f bin -o $(BIN)/boot_2.bin -i Bootloader
	nasm Kernel/zeros.asm -f bin -o $(BIN)/zeros.bin

%.o: %.c
	mkdir -p $(BIN)/$(shell dirname $<)
	$(CC) $(FLAGS) -c $< -o $(BIN)/$(subst .c,.o,$<) $(addprefix -I ,$(shell dirname $(shell echo $(CSRC) | tr ' ' '\n' | sort -u | xargs)))

%.o : %.asm
	mkdir -p $(BIN)/$(shell dirname $<)
	nasm $< -f elf -o $(BIN)/$(subst .asm,.o,$<) $(addprefix -i ,$(shell dirname $(shell echo $(CSRC) | tr ' ' '\n' | sort -u | xargs)))

run: prebuild build
#	qemu-system-x86_64 -drive format=raw,file=os_image.bin,index=0,if=floppy,  -m 128M
	qemu-system-x86_64 -d cpu_reset -drive format=raw,file=$(BIN)/osimage_formated.img,index=0,if=floppy -m 128M
