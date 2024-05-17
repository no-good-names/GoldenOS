# OS Dev makefile for building the kernel and booting it with QEMU

CC = i386-elf-gcc
LD = i386-elf-ld
OBJCOPY = i386-elf-objcopy
QEMU = qemu-system-i386

BIN = bin

all: build

build: boot kernel
	$(LD) -o $(BIN)/kernel.elf -TKernel/kernel.ld $(BIN)/kernel_entry.o $(BIN)/kernel_c.o
	$(OBJCOPY) -O binary $(BIN)/kernel.elf $(BIN)/kernel.bin
	cat bin/boot.bin bin/kernel.bin bin/zeros.bin  > bin/os-image.bin
	dd if=/dev/zero of=bin/os-image_formated.bin bs=512 count=2880 > /dev/null
	dd if=bin/os-image.bin of=bin/os-image_formated.bin conv=notrunc > /dev/null


boot:
	nasm Bootloader/boot.asm -f bin -o bin/boot.bin
	nasm "Kernel/zeros.asm" -f bin -o "bin/zeros.bin"

kernel:
	nasm "Kernel/kernel_entry.asm" -f elf -o "bin/kernel_entry.o"
	$(CC) -ffreestanding -m32 -g -c "Kernel/kernel.c" -o "bin/kernel_c.o"
	$(LD) -o bin/kernel_entry.bin -Ttext 0x1000 bin/kernel_entry.o bin/kernel_c.o --oformat binary

run: build
	$(QEMU) -drive format=raw,file=bin/os-image_formated.bin,index=0,if=floppy, -m 128M

clean:
	rm -rf bin/*

.PHONY: all run clean

