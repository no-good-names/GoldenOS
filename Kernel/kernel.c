#include "../Utils/Typedefs.h"
#include "../Drivers/port_io.h"
#include "../Drivers/VGA_Text.h"

const char *welcome = "Welcome to the kernel!";

extern void main() {
	// Disable cursor
	outb(0x3D4, 0x0A);
	outb(0x3D5, 0x20);
	// Clear screen
	clear_tty(0x07, (char*)0xB8000);
	// Print welcome message
	kprint("Welcome to the kernel!");
	return;
}


