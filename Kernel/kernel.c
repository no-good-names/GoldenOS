extern void printk(const char *string) {
	// Print string to console
	volatile char *video = (volatile char*)0xB8000;
	while(*string != 0) {
		*video++ = *string++;
		*video++ = 0x07;
	}
}

extern void main() {
	printk("Hello, World!");
	return;
}


