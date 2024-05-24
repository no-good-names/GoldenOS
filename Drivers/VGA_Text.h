#ifndef VGA_TEXT_H
#define VGA_TEXT_H

#include "../Utils/Typedefs.h"

int clear_tty(int col, char *tty);
int kprint(const char* string);

#endif // VGA_TEXT_H
