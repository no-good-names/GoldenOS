[bits 32]
section .entry

[extern main]
[global start_kernel]

start_kernel:
	mov [MemSize], bx
	call main

	jmp $

section .text

section .data

global MemSize
MemSize db 0, 0

section .rodata

