ENTRY(start_kernel)
OUTPUT_FORMAT(elf32-i386)

SECTIONS
{
	. = 0x1000;
	.entry : { *(.entry) }
	.text : { *(.text) }
	.rodata : { *(.rodata) }
	.data : { *(.data) }
	.bss : {
		*(COMMON)
		*(.bss)
	}
}

