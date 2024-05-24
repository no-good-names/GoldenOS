#ifndef PORT_H
#define PORT_H

#include "../Utils/Typedefs.h"

void outb(unsigned short port, unsigned char data);
uint8_t inb(unsigned short port);

#endif // PORT_H
