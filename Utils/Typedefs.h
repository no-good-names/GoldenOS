#ifndef TYPEDEFS_H
#define TYPEDEFS_H

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;

/* Boolean type */
/* true = 1, false = 0 */
typedef enum { FALSE = 0, TRUE = 1 } boolean_t;
#define false FALSE
#define true TRUE
#define bool boolean_t

#endif // TYPEDEFS_H
