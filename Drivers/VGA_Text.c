#include "VGA_Text.h"
#include "port_io.h"
#include "../Utils/Typedefs.h"

#define VIDEO_MEMORY	(char*)0xB8000
#define VGA_WIDTH		80
#define VGA_HEIGHT		25

int clear_tty(int col, char *tty) {
	if(!tty) return 1;
	if(col == -1) col = 0x07;
	for(int i = 0; i < 4000; i++ ) {
		if(i % 2 == 0) tty[i] = 32;
		else tty[i] = col;
	}
	return 0;
}

int kprint(const char* string) {
	volatile char* VM = (char*)0xB8000;
	while(*string != 0) {
		*VM++ = *string++;
		*VM++ = 0x07;
	}
	return 0;
}

